class InvitesController < ApplicationController

  require 'mail'

  require 'date'
  require 'logger'

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  layout "application"

  before_filter :require_user
  before_filter :require_owner_or_recipient, :only => [:show]
  #before_filter :require_admin_user, :only => [:index]
  before_filter :require_owner_invite, :except => [:new, :create, :manage_team_invites, :show]


  def valid_email( value )
    begin
     return false if value == ''
     parsed = Mail::Address.new( value )
     return parsed.address == value && parsed.local != parsed.address
    rescue Mail::Field::ParseError
      return false
    end
  end

  def require_owner_or_recipient
    if params[:id]

      invite = Invite.find(params[:id].to_i)
      if invite
        unless (invite.i_am_owner_or_admin(current_user.id) or invite.i_am_recipient(current_user.id))
          flash[:notice] = "You do not have rights to access that page."
          redirect_to "/"
          return false
        end
      end

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

        #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:1")
        begin
          invite = Invite.new()
          invite.purpose_join_team_id = @team.id
          invite.from_user_id = current_user.id
          invite.to_name = params[:invite_name]
          invite.to_email = params[:invite_email]
          invite.first_sent_on = current_user.dtoday

          #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:2")

          if !valid_email(params[:invite_email])
            @invite_create_message = "There was a problem creating the invitation. Make sure you enter a Name and a valid email address."
          else

            #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:3")

            ### do not allow duplicates
            check_invites = Invite.find(:first, :conditions => "purpose_join_team_id = '#{@team.id}' and to_email = '#{params[:invite_email]}'")
            if !check_invites
              if invite.save

                #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:5")

                @invite_create_message = "Invitation created."

                join_url = server_root_url + "/quicksignup_v2?invitation_id=" + invite.id.to_s + "&email=" + invite.to_email + "&to_name=" + invite.to_name + "&form_submitted=1"
                
                #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:6")

                if @team.category_name
                  join_url += "&category=" + @team.category_name
                end

                #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:7")

                if @team.goal_template_parent_id

                  #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:8")
                  goal = Goal.find(@team.goal_template_parent_id)
                  if goal

                    #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:9")
                    join_url += "&template_user_parent_goal_id=" + goal.id.to_s
                    join_url += "&goal_template_text=" + goal.title

                    #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:10")
                  end
                end

                begin

                  logger.info("sgj:invites_controller.rb:manage_team_invites:about to send new invite")

                  #Notifier.deliver_invite_a_friend_to_team(current_user, params[:invite_email], @team.invitation_body.gsub("\n", "<br>") + "<br><br><a href=''>Click Here to Join This Team!</a>", @team.invitation_subject) # sends the email      
                  if Notifier.deliver_invite_a_friend_to_team(current_user, params[:invite_email], @team.invitation_body.gsub("\n", "<br>") + "<br><br><a href='" + join_url + "'>Click Here to Join " + current_user.first_name + "'s Team!</a>", @team.invitation_subject) # sends the email      
                    logger.info("sgj:invites_controller.rb:manage_team_invites:SUCCESS SENDING INVITE EMAIL")                    
                  else
                    logger.error("sgj:invites_controller.rb:manage_team_invites:ERROR SENDING INVITE EMAIL")                    
                  end

                  #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:12")

                  @invite_create_message += " Message sent to " + params[:invite_name] + "."
                rescue

                  #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:13")
                  @invite_create_message += " However, there was a problem sending the email. Contact support@habitforge.com so that we can assist."
                end

                #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:14")

              else
                #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:15")
                @invite_create_message = "There was a problem creating the invitation. Make sure you enter a Name and a valid email address."
              end
              #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:16")
            else
              #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:17")
              @invite_create_message = "You've already sent an invitation to " + params[:invite_email]
            end
            #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:18")
          end

          #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:19")

        rescue

          #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:20")
          @invite_create_message = "Error creating invitation."
        end

        #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:21")

      else
          #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:22")
          @invite_create_message = "Error creating invitation. Invite Name and Email are both required."        
      end

      #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:23")
    end

    #logger.debug("sgj:invites_controller.rb:manage_team_invites:send new invite:24")

    render :partial => "invites/manage_team_invites", :locals => { :team => @team, :invite_create_message => @invite_create_message } 

  end ### end def manage_team_invites





  ### THIS IS GETTING CALLED FROM JS IN _habitforge_app layout:
    # function create_invite_then_reload_manage_program_invites(program_id, invite_name, invite_email) {
    #   //reload div
    #   $('.div_program_'+program_id+'_manage_program_invites').load('/invites/manage_program_invites/1?program_id='+program_id+'&invite_name='+invite_name+'&invite_email='+invite_email);
    # }
  ### http://stackoverflow.com/questions/10539143/reloading-partial-in-an-rails-app
  # GET /invites/manage_program_invites
  def manage_program_invites

    @invite_create_message = ""
    @progam = Program.new()

    if params[:program_id]


      @program = Program.find(params[:program_id].to_i)

      if @program and (!@program.invitation_body or !@program.invitation_subject)
        if !@program.invitation_body
          @program.invitation_body = ""
        end
        if !@program.invitation_subject
          @program.invitation_subject = ""
        end

        @program.save
      end



      if params[:invite_name] and params[:invite_name] != "" and params[:invite_email] and params[:invite_email] != ""

        #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:1")
        begin
          invite = Invite.new()
          invite.purpose_join_program_id = @program.id
          invite.from_user_id = current_user.id
          invite.to_name = params[:invite_name]
          invite.to_email = params[:invite_email]
          invite.first_sent_on = current_user.dtoday

          #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:2")

          if !valid_email(params[:invite_email])
            @invite_create_message = "There was a problem creating the invitation. Make sure you enter a Name and a valid email address."
          else

            #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:3")

            ### do not allow duplicates
            check_invites = Invite.find(:first, :conditions => "purpose_join_program_id = '#{@program.id}' and to_email = '#{params[:invite_email]}'")
            if !check_invites
              if invite.save

                #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:5")

                @invite_create_message = "Invitation created."

                join_url = server_root_url + "/quicksignup_v2?invitation_id=" + invite.id.to_s + "&email=" + invite.to_email + "&to_name=" + invite.to_name + "&form_submitted=1"
                
                #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:6")


                begin

                  logger.info("sgj:invites_controller.rb:manage_program_invites:about to send new invite")

                  #Notifier.deliver_invite_a_friend_to_program(current_user, params[:invite_email], @program.invitation_body.gsub("\n", "<br>") + "<br><br><a href=''>Click Here to Join This Program!</a>", @program.invitation_subject) # sends the email      
                  if Notifier.deliver_invite_a_friend_to_program(current_user, params[:invite_email], @program.invitation_body.gsub("\n", "<br>") + "<br><br><a href='" + join_url + "'>Click Here to Join " + current_user.first_name + "'s " + @program.name + " Program!</a>", @program.invitation_subject) # sends the email      
                    logger.info("sgj:invites_controller.rb:manage_program_invites:SUCCESS SENDING INVITE EMAIL")                    
                  else
                    logger.error("sgj:invites_controller.rb:manage_program_invites:ERROR SENDING INVITE EMAIL")                    
                  end

                  #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:12")

                  @invite_create_message += " Message sent to " + params[:invite_name] + "."
                rescue

                  #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:13")
                  @invite_create_message += " However, there was a problem sending the email. Contact support@habitforge.com so that we can assist."
                end

                #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:14")

              else
                #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:15")
                @invite_create_message = "There was a problem creating the invitation. Make sure you enter a Name and a valid email address."
              end
              #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:16")
            else
              #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:17")
              @invite_create_message = "You've already sent an invitation to " + params[:invite_email]
            end
            #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:18")
          end

          #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:19")

        rescue

          #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:20")
          @invite_create_message = "Error creating invitation."
        end

        #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:21")

      else
          #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:22")
          @invite_create_message = "Error creating invitation. Invite Name and Email are both required."        
      end

      #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:23")
    end

    #logger.debug("sgj:invites_controller.rb:manage_program_invites:send new invite:24")

    render :partial => "invites/manage_program_invites", :locals => { :program => @program, :invite_create_message => @invite_create_message } 

  end ### end def manage_program_invites







  # GET /invites
  # GET /invites.xml
  def index
    @invites = Invite.find(:all, :conditions => "to_user_id = #{current_user.id} or to_email = '#{current_user.email}'")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invites }
    end
  end

  # GET /invites/1
  # GET /invites/1.xml
  def show
    @invite = Invite.find(params[:id])

    logger.debug("sgj:invites_controller:show:1")
    if params[:ignore] and @invite
      logger.debug("sgj:invites_controller:show:1.1")
      @invite.declined_silently_on = current_user.dtoday
      @invite.save
      logger.debug("sgj:invites_controller:show:1.2")      
    end
    logger.debug("sgj:invites_controller:show:2")


    if params[:accept] and @invite
      ###### REDIRECT TO A NEW GOAL MATCHING THE TEAM YOU'RE INVITED TO
      redirect_url_string = "/goals/new?welcome=1"
      redirect_url_string += "&invitation_id=" + @invite.id.to_s

      if @invite.purpose_join_team_id
        team = Team.find(@invite.purpose_join_team_id)
        if team
          if team.category_name
            redirect_url_string += "&category=" + team.category_name
          end
          if team.goal_template_parent_id
            redirect_url_string += "&template_user_parent_goal_id=" + team.goal_template_parent_id.to_s
            goal = Goal.find(team.goal_template_parent_id)
            if goal
              redirect_url_string += "&goal_template_text=" + goal.response_question
            end
          end
        end
      end
    end ### end if params[:accept] and @invite

    if redirect_url_string

      redirect_to(redirect_url_string)

    else

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @invite }
      end

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
