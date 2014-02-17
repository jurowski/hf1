class MessagesController < ApplicationController

  require 'mail'

  require 'date'
  require 'logger'

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  layout "application"


  before_filter :require_user, :except => [:show]
  # before_filter :require_owner_or_recipient, :only => [:show]
  #before_filter :require_admin_user, :only => [:index]
  before_filter :require_owner_message, :except => [:new, :create, :manage_program_messages]


  def require_owner_message
    if params[:id]

      message = Message.find(params[:id].to_i)
      if message

        ### currently only "program" aware
        unless (message.i_am_owner_or_admin(current_user.id))
          flash[:notice] = "You do not have rights to access that page."
          redirect_to "/"
          return false
        end
      end

    end

  end






  ### THIS IS GETTING CALLED FROM JS IN _habitforge_app layout:
    # function create_message_then_reload_manage_program_messages(program_id, subject, body, random_quote, insert_in_webpage) {
    #   //reload div
    #   $('.div_program_'+program_id+'_manage_program_messages').load('/messages/manage_program_messages/1?program_id='+program_id+'&subject='+subject+'&body='+body+'&random_quote='+random_quote+'&insert_into_webpage='+insert_into_webpage);
    # }
  ### http://stackoverflow.com/questions/10539143/reloading-partial-in-an-rails-app
  # GET /invites/manage_program_messages
  def manage_program_messages

KEEP MODIFYING BELOW TO REPLACE INVITE TEXT WITH MESSAGE TEXT

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
                  if Notifier.deliver_invite_a_friend_to_program(current_user, params[:invite_email], @program.invitation_body.gsub("\n", "<br>") + "<br><br><a href='" + join_url + "'>Click Here to Preview " + current_user.first_name + "'s " + @program.name + " Program!</a>", @program.invitation_subject) # sends the email      
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







  # GET /messages
  # GET /messages.xml
  def index
    @messages = Message.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully created.'
        format.html { redirect_to(@message) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end
