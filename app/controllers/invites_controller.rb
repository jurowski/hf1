class InvitesController < ApplicationController

  require 'mail'

  require 'date'
  require 'logger'

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  layout "application"

  before_filter :require_user
  before_filter :require_admin_user, :only => [:index]
  before_filter :require_owner_invite, :except => [:new, :create]


  def valid_email( value )
    begin
     return false if value == ''
     parsed = Mail::Address.new( value )
     return parsed.address == value && parsed.local != parsed.address
    rescue Mail::Field::ParseError
      return false
    end
  end

  def require_owner_invite
    if params[:id]

      invite = Invite.find(params[:id].to_i)
      if invite
        unless (invite.i_am_owner_or_admin(current_user.id))
          flash[:notice] = "You do not have rights to access that page."
          redirect_to "/"
          return false
        end
      end

    end

  end


  ### THIS IS GETTING CALLED FROM JS IN _habitforge_app layout:
    # function create_invite_then_reload_manage_team_invites(team_id, invite_name, invite_email) {
    #   //reload div
    #   $('.div_team_'+team_id+'_manage_team_invites').load('/invites/manage_team_invites/1?team_id='+team_id+'&invite_name='+invite_name+'&invite_email='+invite_email);
    # }
  ### http://stackoverflow.com/questions/10539143/reloading-partial-in-an-rails-app
  # GET /invites/manage_team_invites
  def manage_team_invites

    # @goal = Goal.new()
    # if params[:add_tag_to_template] and params[:goal_id] and params[:tag_id]
    #     @goal = Goal.find(params[:goal_id].to_i)
    #     template_tag = TemplateTag.new()
    #     template_tag.tag_id = params[:tag_id].to_i
    #     template_tag.template_goal_id = params[:goal_id].to_i

    #     ### do not allow duplicates
    #     check_template_tag = TemplateTag.find(:first, :conditions => "template_goal_id = '#{@goal.id.to_i}' and tag_id = '#{params[:tag_id].to_i}'")
    #     if !check_template_tag
    #       template_tag.save
    #     end

    # end

    # if params[:remove_tag_from_template] and params[:goal_id] and params[:tag_id]
    #     @goal = Goal.find(params[:goal_id].to_i)
    #     template_tag = TemplateTag.find(:first, :conditions => "template_goal_id = '#{params[:goal_id]}' and tag_id = '#{params[:tag_id]}'")
    #     template_tag.destroy if template_tag
    # end


    @invite_create_message = ""
    @team = Team.new()


    if params[:team_id]


      @team = Team.find(params[:team_id].to_i)


      if params[:invite_name] and params[:invite_name] != "" and params[:invite_email] and params[:invite_email] != ""


        begin
          invite = Invite.new()
          invite.purpose_join_team_id = @team.id
          invite.from_user_id = current_user.id
          invite.to_name = params[:invite_name]
          invite.to_email = params[:invite_email]
          invite.first_sent_on = current_user.dtoday


          if !valid_email(params[:invite_email])
            @invite_create_message = "There was a problem creating the invitation. Make sure you enter a Name and a valid email address."
          else
            ### do not allow duplicates
            check_invites = Invite.find(:first, :conditions => "purpose_join_team_id = '#{@team.id}' and to_email = '#{params[:invite_email]}'")
            if !check_invites
              if invite.save
                @invite_create_message = "Invitation created."

                begin
                  Notifier.deliver_invite_a_friend_to_team(current_user, params[:invite_email], @team.invitation_body.gsub("\n", "<br>") + "<br><br> The HabitForge URL is: http://habitforge.com", @team.invitation_subject) # sends the email      
                  @invite_create_message += " Message sent to " + params[:invite_name] + "."
                rescue
                  @invite_create_message += " However, there was a problem sending the email. Contact support@habitforge.com so that we can assist."
                end

              else
                @invite_create_message = "There was a problem creating the invitation. Make sure you enter a Name and a valid email address."
              end
            else
              @invite_create_message = "You've already sent an invitation to " + params[:invite_email]
            end
          end



        rescue

          @invite_create_message = "Error creating invitation."
        end

      else
          @invite_create_message = "Error creating invitation. Invite Name and Email are both required."        
      end
    end

    render :partial => "invites/manage_team_invites", :locals => { :team => @team, :invite_create_message => @invite_create_message } 

  end

  # GET /invites
  # GET /invites.xml
  def index
    @invites = Invite.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invites }
    end
  end

  # GET /invites/1
  # GET /invites/1.xml
  def show
    @invite = Invite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invite }
    end
  end

  # GET /invites/new
  # GET /invites/new.xml
  def new
    @invite = Invite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invite }
    end
  end

  # GET /invites/1/edit
  def edit
    @invite = Invite.find(params[:id])
  end

  # POST /invites
  # POST /invites.xml
  def create
    @invite = Invite.new(params[:invite])

    respond_to do |format|
      if @invite.save
        flash[:notice] = 'Invite was successfully created.'
        format.html { redirect_to(@invite) }
        format.xml  { render :xml => @invite, :status => :created, :location => @invite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invites/1
  # PUT /invites/1.xml
  def update
    @invite = Invite.find(params[:id])

    respond_to do |format|
      if @invite.update_attributes(params[:invite])
        flash[:notice] = 'Invite was successfully updated.'
        format.html { redirect_to(@invite) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invites/1
  # DELETE /invites/1.xml
  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy

    respond_to do |format|
      format.html { redirect_to(invites_url) }
      format.xml  { head :ok }
    end
  end
end
