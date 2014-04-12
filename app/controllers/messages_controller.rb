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
  #before_filter :require_owner_message, :except => [:new, :create, :manage_program_messages]
  before_filter :require_owner_message, :except => [:new, :create]


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
    # function create_message_then_reload_manage_program_messages(program_id, subject, body, random_quote, for_this_date_only, insert_in_checkin_emails, insert_in_reminder_emails, insert_in_webpage) {
    #   //reload div
    #   $('.div_program_'+program_id+'_manage_program_messages').load('/messages/manage_program_messages/1?program_id='+program_id+'&subject='+subject+'&body='+body+'&random_quote='+random_quote+'&for_this_date_only='+for_this_date_only+'&insert_in_checkin_emails='+insert_in_checkin_emails&insert_in_reminder_emails='+insert_in_reminder_emails&insert_in_webpage='+insert_in_webpage);
    # }
  ### http://stackoverflow.com/questions/10539143/reloading-partial-in-an-rails-app
  # GET /invites/manage_program_messages
  def manage_program_messages


    @program_message_status = ""
    @progam = Program.new()

    if params[:program_id]

      @program = Program.find(params[:program_id].to_i)


      @destroyed_message = false
      #############################
      ### DESTROY
      #############################
      if params[:remove_message_id]
        m = Message.find(params[:remove_message_id].to_i)
        if m
          m.destroy
          @destroyed_message = true
        end
      end


      #############################
      ### CREATE
      #############################
      ### Params:
      ### program_id:subject:body:random_quote:for_this_date_only:insert_in_checkin_emails:insert_in_reminder_emails:insert_in_webpage
      if params[:body] \
        and params[:template_goal_id] \
        and params[:body] != "" \
        and params[:subject] \
        and params[:random_quote] \
        and params[:for_this_date_only] \
        and params[:insert_in_checkin_emails] \
        and params[:insert_in_reminder_emails] \
        and params[:insert_in_webpage]

        logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:1")
        begin
          m = Message.new()

          ### REQUIRED PARAMS
          # t.integer  "program_id"
          # t.integer  "template_goal_id"
          # t.text     "body"
          # t.string   "subject"
          # t.boolean  "random_quote"
          # t.date     "for_this_date_only"
          # t.boolean  "insert_in_checkin_emails"
          # t.boolean  "insert_in_reminder_emails"
          # t.boolean  "insert_in_webpage"

          m.program_id = @program.id
          m.body = params[:body]
          m.subject = params[:subject]

          if params[:template_goal_id] != ""
            m.template_goal_id = params[:template_goal_id].to_i
          end

          if params[:random_quote] != ""
            m.random_quote = true
          end

          if params[:for_this_date_only] != ""
            m.for_this_date_only = params[:for_this_date_only]
          end

          if params[:insert_in_checkin_emails] == "true"
            m.insert_in_checkin_emails = true
          end

          if params[:insert_in_reminder_emails] == "true"
            m.insert_in_reminder_emails = true
          end

          if params[:insert_in_webpage] == "true"
            m.insert_in_webpage = true
          end


          logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:2")

          ### do not allow duplicates
          check_messages = Message.find(:first, :conditions => "program_id = '#{@program.id}' and body = '#{params[:body]}'")
          if !check_messages
            if m.save
              #logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:3")
              @program_message_status = "Message created."
            else
              #logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:4")
              @program_message_status = "There was a problem creating the message."
            end
            #logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:5")
          else
            #logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:6")
            @program_message_status = "Message already exists."
          end
          #logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:7")

        rescue

          #logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:8")
          @program_message_status = "Error creating message."
        end

        #logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:9")

      else
          if @destroyed_message
            @program_message_status = "Message deleted."
          else
            #logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:10")
            @program_message_status = "Error creating message. Missing parameters."
          end
      end

      #logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:11")
    end
    #logger.debug("sgj:messages_controller.rb:manage_program_messages:create new message:12")

    render :partial => "messages/manage_program_messages", :locals => { :program => @program, :program_create_message => @program_message_status } 

  end ### end def manage_program_messages







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

        if @message.program
          
          format.html { redirect_to(@message.program) }
          format.xml  { head :ok }

        else
          format.html { redirect_to(@message) }
          format.xml  { head :ok }
        end

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
