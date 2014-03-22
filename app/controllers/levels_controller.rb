class LevelsController < ApplicationController
  # GET /levels
  # GET /levels.xml
  def index
    @levels = Level.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @levels }
    end
  end

  # GET /levels/1
  # GET /levels/1.xml
  def show
    @level = Level.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @level }
    end
  end

  # GET /levels/new
  # GET /levels/new.xml
  def new
    @level = Level.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @level }
    end
  end

  # GET /levels/1/edit
  def edit
    @level = Level.find(params[:id])
  end

  # POST /levels
  # POST /levels.xml
  def create
    @level = Level.new(params[:level])

    respond_to do |format|
      if @level.save
        flash[:notice] = 'Level was successfully created.'
        format.html { redirect_to(@level) }
        format.xml  { render :xml => @level, :status => :created, :location => @level }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /levels/1
  # PUT /levels/1.xml
  def update
    @level = Level.find(params[:id])

    respond_to do |format|
      if @level.update_attributes(params[:level])
        flash[:notice] = 'Level was successfully updated.'
        format.html { redirect_to(@level) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /levels/1
  # DELETE /levels/1.xml
  def destroy
    @level = Level.find(params[:id])
    @level.destroy

    respond_to do |format|
      format.html { redirect_to(levels_url) }
      format.xml  { head :ok }
    end
  end





  ### THIS IS GETTING CALLED FROM JS IN _habitforge_app layout:
    # function create_level_then_reload_manage_program_levels(program_id, next_level_id, this_is_the_first_level, points, name, description, trigger_id, first_template_goal_id) {
    #   //reload div
    #   $('.div_program_'+program_id+'_manage_program_levels').load('/levels/manage_program_levels/1?program_id='+program_id+'&next_level_id='+next_level_id+'&this_is_the_first_level='+this_is_the_first_level+'&points='+points+'&name='+name+'&description='+description&trigger_id='+trigger_id&first_template_goal_id='+first_template_goal_id);
    # }
  ### http://stackoverflow.com/questions/10539143/reloading-partial-in-an-rails-app
  # GET /levels/manage_program_levels
  def manage_program_levels


    @program_level_status = ""
    @progam = Program.new()

    if params[:program_id]

      @program = Program.find(params[:program_id].to_i)


      @destroyed_level = false
      #############################
      ### DESTROY
      #############################
      if params[:remove_level_id]
        l = Level.find(params[:remove_level_id].to_i)
        if l
          l.destroy
          @destroyed_level = true
        end
      end


      #############################
      ### CREATE
      #############################
      ### Params:
      ### next_level_id:this_is_the_first_level:points:name:description:trigger_id:first_template_goal_id
      if params[:next_level_id] \
        and params[:this_is_the_first_level] \
        and (params[:description] and params[:description] != "") \
        and params[:trigger_id] \
        and params[:first_template_goal_id]

        logger.debug("sgj:levels_controller.rb:manage_program_levelss:create new level:1")
        begin
          l = Level.new()

          ### REQUIRED PARAMS
          #   t.integer  "program_id"
          #   t.integer  "next_level_id"
          #   t.boolean  "this_is_the_first_level"
          #   t.integer  "points"
          #   t.string   "name"
          #   t.text     "description"
          #   t.integer  "trigger_id"
          #   t.integer  "first_template_goal_id"

          l.program_id = @program.id
          l.body = params[:body]
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





end
