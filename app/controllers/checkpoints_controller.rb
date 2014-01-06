class CheckpointsController < ApplicationController
  require 'date'
  layout "application"
  include ApplicationHelper
  include GoalsHelper
  require 'logger'

  before_filter :require_user, :only => [:view_checkpoint_multiple_email, :view_checkpoint_single_email, :show, :new, :edit, :destroy, :update]

  before_filter :require_admin_user, :only => [:index]
  
  # GET /checkpoints
  # GET /checkpoints.xml
  def index

    # ex:
    # SELECT status, COUNT( * ) AS count FROM checkpoints
    # WHERE checkin_date = '2014-01-01'
    # GROUP BY status

    # produces:
    # email not yet sent
    # 12

    # email queued
    # 67

    # email sent
    # 450

    # no
    # 277

    # yes
    # 593

    @params_sent = ""
    if params[:find_date]
      @params_sent += "find_date=<%= params[:find_date] %>"
    end
    if params[:find_status]
      @params_sent += "&find_status=<%= params[:find_status]"
    end
    if params[:find_email]
      @params_sent += "&find_email=<%= params[:find_email]"
    end

    
    @conditions = "id = 99999999"

    if params[:find_date] and params[:find_date] != ""
      @conditions = "checkin_date = '#{params[:find_date]}'"

      if params[:find_status] and params[:find_status] != ""
        @conditions += " and status = '#{params[:find_status]}'"
      end

      if params[:find_email] and params[:find_email] != ""
        user = User.find(:first, :conditions => "email = '#{params[:find_email]}'")
        if user
          found_one = false
          user.active_goals.each do |goal|
            if !found_one
              @conditions += " and ("
            else
              @conditions += " or"
            end
            @conditions += " goal_id = #{goal.id}"
            if !found_one
              @conditions += ")"
              found_one = true
            end
          end
        end
      end

    end


    @checkpoints = Checkpoint.paginate(:page => params[:page],
                               :per_page   => 10,
                               :order      => 'status DESC',
                               :conditions => @conditions)
  end

  def view_checkpoint_single_email
    @checkpoint = Checkpoint.find(params[:id])
  end

  def view_checkpoint_multiple_email
    @checkpoint = Checkpoint.find(params[:id])
  end


  # GET /checkpoints/1
  # GET /checkpoints/1.xml
  def show
    @checkpoint = Checkpoint.find(params[:id])
    if @checkpoint == nil
        redirect_to account_url
    end
    if @checkpoint.goal == nil
        redirect_to account_url
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @checkpoint }
    end
  end

  # GET /checkpoints/new
  # GET /checkpoints/new.xml
  def new
    ### disable it
    redirect_to(server_root_url)
  end

  # GET /checkpoints/1/edit
  def edit
    @checkpoint = Checkpoint.find(params[:id])
    if @checkpoint == nil
        redirect_to account_url
    end
    if @checkpoint.goal == nil
        redirect_to account_url
    end

    if @checkpoint.goal == nil
        redirect_to account_url
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @checkpoint }
    end
  end


  # POST /checkpoints
  # POST /checkpoints.xml
  def create
    @checkpoint = Checkpoint.new(params[:checkpoint])

    respond_to do |format|
      if @checkpoint.save
        flash[:notice] = 'Checkpoint was successfully created.'
        format.html { redirect_to(@checkpoint) }
        format.xml  { render :xml => @checkpoint, :status => :created, :location => @checkpoint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @checkpoint.errors, :status => :unprocessable_entity }
      end
    end
  end

  def autoupdatemultiple

    ### EXAMPLE URLS: 
    ###  http://habitforge.com/checkpoints/1/autoupdatemultiple?d=2012-01-26&u=29103&g=111490

    ###  jurowski@gmail.com
    ###  http://localhost:3000/checkpoints/1/autoupdatemultiple?d=2012-01-26&u=44&g=25861

    ###  jurowski@wisc.edu
    ###  http://localhost:3000/checkpoints/1/autoupdatemultiple?d=2012-01-26&u=15706&g=25858



    if session[:sponsor] == nil or session[:sponsor] == "" or session[:sponsor] == "habitforge"
      session[:site_name] = "habitforge"
      session[:support_email] = "support@habitforge.com"
    end
    if request.domain.include? 'mylearninghabit' or session[:sponsor] == "clearworth"
    	session[:site_name] = "My Learning Habit"
      session[:support_email] = "support@habitforge.com"
    end
    if request.domain.include? 'forittobe' or session[:sponsor] == "forittobe"
    	session[:site_name] = "For It To Be"
      session[:support_email] = "support@forittobe.com"	
    end
    if request.domain.include? 'marriagereminders' or session[:sponsor] == "marriagereminders"
    	session[:site_name] = "Marriage Reminders"
      session[:support_email] = "support@marriagereminders.com"	
    end
    if request.domain.include? 'eathealthy' or session[:sponsor] == "eathealthy"
      session[:site_name] = "habitforge"
      session[:support_email] = "support@habitforge.com"
    end
  
    if params[:d] 
      session[:d] = params[:d]
    end
    if params[:u] 
      session[:u] = params[:u]
    end
    if params[:g] 
      session[:g] = params[:g]
    end


    @goal = Goal.find(session[:g])  


    if @goal
      logger.info("sgj:controller:checkpoints:autoupdatemultiple: found goal with id: " + @goal.id.to_s)
    end

    #@goals_additional = Goal.find(:all, :conditions => "user_id = '#{@goal.user_id}' and status !='hold' ")
    @day_of_checkpoints = Date.parse(session[:d]).strftime("%a, %b %d, %Y")
    @goals_additional = @goal.user.all_goals_working_on_for_date(Date.parse(session[:d]))

    logger.info("sgj:controller:checkpoints:autoupdatemultiple: @goals_additional.size = " + @goals_additional.size.to_s)
  
    for goal_additional in @goals_additional

      logger.info("sgj:controller:checkpoints:autoupdatemultiple:goal_additional.title = " + goal_additional.title)

      @checkpoint = Checkpoint.find(:first, :conditions => "goal_id = '#{goal_additional.id}' and checkin_date = '#{session[:d]}'")
      if @checkpoint != nil
        id = @checkpoint.id
        status_id = "status_" + id.to_s
        comment_id = "comment_" + id.to_s
        if params[:submitted]
          ### the form was submitted... save answers          
          status = ""
          comment = ""
          ### DO NOT PUT COLONS HERE
          if params[status_id]
            ### DO NOT PUT COLONS HERE              
            status = params[status_id]
          end
          ### DO NOT PUT COLONS HERE
          if params[comment_id]
            ### DO NOT PUT COLONS HERE
            comment = params[comment_id]
          end
          ##### Saving and goal/stats updates is all done by the "goal.update_checkpoint" function 
          @checkpoint.goal.update_checkpoint(@checkpoint.checkin_date, status, comment)
        end            
      end  
    end
    if params[:submitted]
        ### redirect to "goals/index" and fake log them in if needed
        redirect_to("/goals?e0=#{@goal.user.email[0]}&f0=#{@goal.user.first_name[0]}&u=#{@goal.user.id}&goal_id=#{@goal.id}&coming_from=multiple") 
    end

  end
  
  
  
  def autoupdatemultipleradio

  end

  def autoupdate
    ### IF COMING FROM OLD-STYLE EMAIL LINK, REDIRECT
    ### OLD MODE (AUTOUPDATE METHOD) http://localhost:3000/checkpoints/1080987/autoupdate?status=yes&return_to=goals&u=15706&g=25855
    ### NEW MODE EXAMPLE URL: http://localhost:3000/goals?update_checkpoint_status=no&date=2012-01-28&e0=106&f0=97&u=15706&goal_id=25855

    @checkpoint = Checkpoint.find(params[:id])
    if @checkpoint == nil
        redirect_to account_url
    end
    if @checkpoint.goal == nil
        redirect_to account_url
    end
    redirect_to "/goals?update_checkpoint_status=#{params[:status]}&date=#{params[:checkin_date]}&e0=#{@checkpoint.goal.user.email[0]}&f0=#{@checkpoint.goal.user.first_name[0]}&u=#{@checkpoint.goal.user.id}&goal_id=#{@checkpoint.goal.id}"

  end

  #def autoupdate
  #
  #
  #  
  #  ### OLD MODE (AUTOUPDATE METHOD) http://localhost:3000/checkpoints/1080987/autoupdate?status=yes&return_to=goals&u=15706&g=25855
  #  ### NEW MODE EXAMPLE URL: http://localhost:3000/goals?update_checkpoint_status=no&date=2012-01-28&e0=106&f0=97&u=15706&goal_id=25855
  #
  #  
  #  missing_answers_since_start_date = 0
  #  @print_days_straight = ""    
  #  @print_wheel = ""
  #  daysstraight = 0
  #  
  #  ########################
  #  ### GET DATE NOW ###
  #  ########################
  #  dnow = get_dnow + 0
  #  dyesterday = dnow - 1
  #  ########################
  #  
  #  
  #  #########################################
  #  #### FIND CHECKPOINT, SAVE THE STATUS
  #  #########################################
  #  if params[:save_checkpoint]
  #    ### from the autoupdatemultiple page
  #    @checkpoint = Checkpoint.find(params[:save_checkpoint])
  #  else
  #    @checkpoint = Checkpoint.find(params[:id])      
  #  end
  #  @checkpoint.status = params[:status]
  #  @checkpoint.save
  #  #########################################
  #  ### END FIND CHECKPOINT, SAVE THE STATUS
  #  #########################################
  #
  #
  #  if @checkpoint.goal != nil
  #      ### it would be nil if the goal had been deleted w/out the checkpoints being deleted
  #      ### this does seem to happen somehow now and then
  #      
  #
  #      #########################################
  #      ### FILL IN ANY CHECKPOINT GAPS
  #      ### CREATE CHECKPOINTS WHERE MISSING
  #      #########################################
  #      
  #      
  #      ### Does a checkpoint exist yet for "yesterday"? Do that first if needed
  #      ### (don't do "today" since that will cause stats to say "unsure")
  #      @checkpoint_today = Checkpoint.find(:first, :conditions => "goal_id = '#{@checkpoint.goal.id}' and checkin_date = '#{dnow}'")
  #      if @checkpoint_today == nil
  #          new_checkpoint_date = dnow - 1
  #          create_this_missing_checkpoint = 0
  #          dayname = new_checkpoint_date.strftime("%A")
  #          #puts "Yesterday was a #{dayname}"
  #          if dayname == "Monday"
  #            day_name = "daym"
  #            if @checkpoint.goal.daym == true
  #                create_this_missing_checkpoint = 1
  #            end
  #          end
  #          if dayname == "Tuesday"
  #            day_name = "dayt"
  #            if @checkpoint.goal.dayt == true
  #                create_this_missing_checkpoint = 1
  #            end
  #          end
  #          if dayname == "Wednesday"
  #            day_name = "dayw"
  #            if @checkpoint.goal.dayw == true
  #                create_this_missing_checkpoint = 1
  #            end
  #          end
  #          if dayname == "Thursday"
  #            day_name = "dayr"
  #            if @checkpoint.goal.dayr == true
  #                create_this_missing_checkpoint = 1
  #            end
  #          end
  #          if dayname == "Friday"
  #            day_name = "dayf"
  #            if @checkpoint.goal.dayf == true
  #                create_this_missing_checkpoint = 1
  #            end
  #          end
  #          if dayname == "Saturday"
  #            day_name = "days"
  #            if @checkpoint.goal.days == true
  #                create_this_missing_checkpoint = 1
  #            end
  #          end
  #          if dayname == "Sunday"
  #            day_name = "dayn"
  #            if @checkpoint.goal.dayn == true
  #                create_this_missing_checkpoint = 1
  #            end
  #          end
  #
  #          if create_this_missing_checkpoint == 1
  #              @double_check_checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{@checkpoint.goal.id}' and checkin_date = '#{new_checkpoint_date}'")
  #              if @double_check_checkpoints.size == 0
  #                  logger.debug day_name + ' is a go... create this missing checkpoint'
  #                  #### START CREATE CHECK POINT
  #                  c_new = Checkpoint.new
  #                  c_new.goal_id = @checkpoint.goal.id
  #                  c_new.checkin_date = new_checkpoint_date
  #                  c_new.status = "email not yet sent"
  #                  c_new.syslognote = "checkpoint created late, during auto-update process"
  #                  if c_new.save
  #                    logger.info 'created missing checkpoint for user ' + c_new.goal.user.email + ' for goal of ' + c_new.goal.id.to_s + ' and date of ' + c_new.checkin_date.to_s
  #                  else
  #                    logger.info 'error creating missing checkpoint for user ' + c_new.goal.user.email + ' for goal of ' + c_new.goal.id.to_s + ' and date of ' + c_new.checkin_date.to_s
  #                  end
  #                  #### END CREATE CHECKPOINT
  #              end
  #          else
  #              logger.debug day_name + ' is a skip day'
  #          end
  #      end
  #      
  #      ### NOW CHECK FOR GAPS AND FILL IN WHERE NEEDED
  #      @checkpoints_all = Checkpoint.find(:all, :conditions => "goal_id = '#{@checkpoint.goal.id}'", :order =>  "checkin_date desc")
  #      if @checkpoints_all != nil
  #          passed_the_first_one = 0
  #          previous_date = dnow - 1
  #          for c in @checkpoints_all
  #              if passed_the_first_one == 0
  #                  passed_the_first_one = 1
  #                  previous_date = c.checkin_date
  #                  logger.debug 'first checkpoint date =' + previous_date.to_s
  #              else
  #                  gap = previous_date - c.checkin_date
  #                  logger.debug 'gap between ' + previous_date.to_s + ' and ' + c.checkin_date.to_s + ' = ' + gap.to_s
  #                  if gap > 1
  #                      logger.debug 'GAP GREATER THAN 1... CHECK FOR DAYS OF WEEK'
  #
  #                      traverse_counter = 1
  #                      while traverse_counter < gap
  #                          new_checkpoint_date = previous_date - traverse_counter
  #                          
  #                          create_this_missing_checkpoint = 0
  #                          dayname = new_checkpoint_date.strftime("%A")
  #                          #puts "Yesterday was a #{dayname}"
  #                          if dayname == "Monday"
  #                            day_name = "daym"
  #                            if c.goal.daym == true
  #                                create_this_missing_checkpoint = 1
  #                            end
  #                          end
  #                          if dayname == "Tuesday"
  #                            day_name = "dayt"
  #                            if c.goal.dayt == true
  #                                create_this_missing_checkpoint = 1
  #                            end
  #                          end
  #                          if dayname == "Wednesday"
  #                            day_name = "dayw"
  #                            if c.goal.dayw == true
  #                                create_this_missing_checkpoint = 1
  #                            end
  #                          end
  #                          if dayname == "Thursday"
  #                            day_name = "dayr"
  #                            if c.goal.dayr == true
  #                                create_this_missing_checkpoint = 1
  #                            end
  #                          end
  #                          if dayname == "Friday"
  #                            day_name = "dayf"
  #                            if c.goal.dayf == true
  #                                create_this_missing_checkpoint = 1
  #                            end
  #                          end
  #                          if dayname == "Saturday"
  #                            day_name = "days"
  #                            if c.goal.days == true
  #                                create_this_missing_checkpoint = 1
  #                            end
  #                          end
  #                          if dayname == "Sunday"
  #                            day_name = "dayn"
  #                            if c.goal.dayn == true
  #                                create_this_missing_checkpoint = 1
  #                            end
  #                          end
  #
  #
  #                          if create_this_missing_checkpoint == 1
  #                              logger.debug day_name + ' is a go... create this missing checkpoint'
  #
  #                              @double_check_checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{c.goal.id}' and checkin_date = '#{new_checkpoint_date}'")
  #                              if @double_check_checkpoints.size == 0
  #                                #### START CREATE CHECK POINT
  #                                c_new = Checkpoint.new
  #                                c_new.goal_id = c.goal.id
  #                                c_new.checkin_date = new_checkpoint_date
  #                                c_new.status = "email not yet sent"
  #                                c_new.syslognote = "checkpoint created late, during auto-update process"
  #                                if c_new.save
  #                                  logger.info 'created missing checkpoint for user ' + c_new.goal.user.email + ' for goal of ' + c_new.goal.id.to_s + ' and date of ' + c_new.checkin_date.to_s
  #                                else
  #                                  logger.info 'error creating missing checkpoint for user ' + c_new.goal.user.email + ' for goal of ' + c_new.goal.id.to_s + ' and date of ' + c_new.checkin_date.to_s
  #                                end
  #                                #### END CREATE CHECKPOINT
  #                              end    
  #                          else
  #                              logger.debug day_name + ' is a skip day'
  #                          end
  #                          traverse_counter = traverse_counter + 1
  #
  #                      end
  #                  end
  #                  previous_date = c.checkin_date
  #              end
  #          end
  #      end
  #      #########################################
  #      ### END FILL IN ANY CHECKPOINT GAPS
  #      ### END CREATE CHECKPOINTS WHERE MISSING
  #      #########################################
  #      
  #      
  #      #############################################################
  #      ######      ANSWERED NO, RESET THE START AND STOP DATES
  #      #############################################################
  #      ### if a "started" goal checkpoint is set to "no", 
  #      ### and if it's after the goal start date, 
  #      ### then a new start date (and stop date) should be set, 
  #      ### where the new start date is one day after the last occurrence of "no"
  #      @checkpoints_all = Checkpoint.find(:first, :conditions => "goal_id = '#{@checkpoint.goal.id}'", :order =>  "checkin_date desc")
  #      if @checkpoints_all != nil
  #        if @checkpoints_all.status == 'no'
  #          @checkpoint.goal.daysstraight = 0
  #          @checkpoint.goal.save
  #          if @checkpoint.goal.status == "start"
  #            @print_days_straight << "<p>We'll reset the clock back to day one.</p>"
  #            @print_wheel << '<img src="/images/ring_buttons0.png" alt="Starting over" width=100/>'
  #          end
  #        end
  #      end
  #      if @checkpoint.status == "no" and @checkpoint.goal.status == "start" and @checkpoint.checkin_date >= @checkpoint.goal.start
  #        newstart = dnow
  #        @checkpoints_no = Checkpoint.find(:all, :conditions => "goal_id = '#{@checkpoint.goal.id}' and status = 'no'", :order =>  "checkin_date asc")
  #        for checkpoint in @checkpoints_no
  #          newstart = checkpoint.checkin_date + 1
  #        end
  #        #set_start_date(@checkpoint.goal.id, newstart)
  #        #set_stop_date(@checkpoint.goal.id, 0)
  #
  #        @checkpoint.goal.start = newstart
  #        @checkpoint.goal.stop = @checkpoint.goal.start + 21
  #
  #        @checkpoint.goal.save
  #      end
  #      #############################################################
  #      ######      END ANSWERED NO, RESET THE START AND STOP DATES
  #      #############################################################
  #
  #  
  #
  #      #####################################################################
  #      #### Update the goal w/ the last status and date (if it is the last)
  #      #####################################################################
  #      laststatusdate = @checkpoint.goal.laststatusdate
  #      if laststatusdate == nil
  #        laststatusdate = Date.new(1900,1,1)
  #      end
  #      if @checkpoint.checkin_date > laststatusdate
  #        @checkpoint.goal.laststatusdate = @checkpoint.checkin_date
  #        @checkpoint.goal.laststatus = @checkpoint.status
  #        @checkpoint.goal.save
  #      end
  #      #####################################################################
  #      #### END Update the goal w/ the last status and date (if it is the last)
  #      #####################################################################
  #
  #  
  #  
  #      #####################################################################
  #      ###      Reset the start date if needed
  #      #####################################################################    
  #  
  #      ### only if the goal is not monitored
  #      if @checkpoint.goal.status != 'monitor'
  #        keep_going = "yes"
  #        first_checkpoint_date = dnow
  #    
  #        ### count backward from the most recent checkpoints
  #        @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{@checkpoint.goal.id}'", :order =>  "checkin_date desc")
  #        for checkpoint in @checkpoints
  #          ### if you have reason to keep looking backward for a new start date
  #          if keep_going == "yes"
  #            ### the first "no" that you come across, that + 1 is your new start date and you can stop looking
  #            if checkpoint.status == "no"
  #              newstart = checkpoint.checkin_date + 1            
  #              keep_going = "no"
  #            end 
  #          end  
  #          first_checkpoint_date = checkpoint.checkin_date
  #        end 
  #        if keep_going == "yes"
  #          ### you never found a "no", so just to be safe, reset your start date to the first checkpoint's date
  #          newstart = first_checkpoint_date
  #        end                   
  #        @checkpoint.goal.start = newstart
  #        @checkpoint.goal.stop = @checkpoint.goal.start + 21
  #        @checkpoint.goal.save
  #      end
  #      #####################################################################
  #      ###      End reset the start date if needed
  #      #####################################################################    
  #
  #
  #
  #      @checkpoint.goal.update_daysstraight
  #      @checkpoint.goal.update_longest_run
  #
  #
  #      ############################################################
  #      ##### START BUILD OUTPUT for DAYSSTRAIGHT AND WHEEL ########
  #      ############################################################
  #      @checkpoints_gone_by = Checkpoint.find(:all, :conditions => "@goal_id = '#{@checkpoint.goal.id}' and checkin_date >= '#{@checkpoint.goal.start}'")
  #      daysgoneby = @checkpoints_gone_by.size
  #      @daysleft = 21 - @checkpoint.goal.daysstraight
  #
  #      if @checkpoint.goal.daysstraight > 0 or (@checkpoint.status == "yes" and (@checkpoint.goal.status == "start" or @checkpoint.goal.status == "monitor") and @daysleft > 0)
  #        @checkpoints_missing = Checkpoint.find(:all, :conditions => "goal_id = '#{@checkpoint.goal.id}' and checkin_date >= '#{@checkpoint.goal.start}' and checkin_date <= '#{@checkpoint.goal.stop}' and status = 'email sent'")
  #        if @checkpoint.goal.daysstraight == 9999
  #          if dnow > @checkpoint.goal.stop
  #            #expired
  #          else
  #            @missing_answers_since_start_date = 1
  #            @print_days_straight << '<br><img src="/images/question.png" alt="Missing checkpoints" width = 25/>'
  #            @print_days_straight << "<p>Not sure yet on the days in a row.<br>(There are unanswered checkpoints after the start date)."
  #          end
  #        else
  #           @print_days_straight << "<p><strong>You've succeeded #{@checkpoint.goal.daysstraight} "
  #           if @checkpoint.goal.daysstraight == 1
  #             @print_days_straight << "day "
  #           else
  #             @print_days_straight << "days "
  #           end
  #           @print_days_straight << "in a row.</strong><br>"
  #
  #          if @checkpoint.goal.longestrun != nil and @checkpoint.goal.longestrun > 2
  #              if @checkpoint.goal.daysstraight == @checkpoint.goal.longestrun
  #                @print_days_straight << " ...your longest run yet! <br>"
  #              else
  #                @print_days_straight << " (longest run so far is #{@checkpoint.goal.longestrun})<br>"
  #              end
  #          end
  #
  #           if @checkpoint.goal.status == "start"
  #             @print_days_straight << "Only #{@daysleft} more "
  #             if @daysleft == 1
  #               @print_days_straight << "day "
  #             else
  #               @print_days_straight << "days "
  #             end
  #             @print_days_straight << "to go!</p>"
  #             @print_wheel << "<img src='/images/ring_buttons#{@checkpoint.goal.daysstraight}.png' alt='#{@checkpoint.goal.daysstraight} days in a row' width=100 />"
  #           end        
  #        end
  #      end
  #      ############################################################
  #      ##### END BUILD OUTPUT for DAYSSTRAIGHT AND WHEEL ########
  #      ############################################################
  #
  #
  #
  #
  #
  #      ############################################################
  #      ##### DETERMINE WHETHER GOAL HAS BEEN ESTABLISHED ########
  #      ############################################################
  #      @checkpoints_range = Checkpoint.find(:all, :conditions => "goal_id = '#{@checkpoint.goal.id}' and checkin_date >= '#{@checkpoint.goal.start}' and checkin_date <= '#{@checkpoint.goal.stop}' and status = 'yes'")
  #      mystring = @checkpoints_range.size
  #      if @checkpoint.goal.status == "start" and @checkpoints_range.size > 20
  #        @checkpoints_missing = Checkpoint.find(:all, :conditions => "goal_id = '#{@checkpoint.goal.id}' and checkin_date >= '#{@checkpoint.goal.start}' and checkin_date <= '#{@checkpoint.goal.stop}' and status = 'email sent'")
  #        if @checkpoints_missing.size > 0
  #          ###missing checkpoints, can't call it yet
  #        else
  #          ### goal has been met... set established_on date
  #          @checkpoint.goal.established_on = @checkpoint.goal.stop
  #          @checkpoint.goal.save        
  #
  #          puts "10 #{@checkpoint.goal.start}-#{@checkpoint.goal.stop}"
  #
  #        end
  #      end
  #      flash[:notice] = 'Checkpoint was successfully updated.'      
  #      ############################################################
  #      ##### END DETERMINE WHETHER GOAL HAS BEEN ESTABLISHED ########
  #      ############################################################
  #
  #
  #
  #
  #      ####################################################
  #      ####    CALCULATE STATS
  #      ####################################################
  #      @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{@checkpoint.goal.id}'")
  #      totalsize = @checkpoints.size
  #      if totalsize > 0
  #        @no = Checkpoint.find(:all, :conditions => "status = 'no' and goal_id = '#{@checkpoint.goal.id}'")
  #        no_percent = (((@no.size + 0.0) / totalsize)*100).floor  
  #        @yes = Checkpoint.find(:all, :conditions => "status = 'yes' and goal_id = '#{@checkpoint.goal.id}'")
  #        @yes_percent = (((@yes.size + 0.0) / totalsize)*100).floor 
  #    
  #        @checkpoint.goal.success_rate_percentage = @yes_percent
  #        @checkpoint.goal.days_into_it = totalsize
  #        @checkpoint.goal.save      
  #    
  #        @missing = Checkpoint.find(:all, :conditions => "status = 'email sent' and goal_id = '#{@checkpoint.goal.id}'")
  #        # Convert these Ints into Floats by adding 0.0
  #        missing = @missing.size + 0.0
  #        total = totalsize + 0.0
  #        missing_percent = ((missing / total)*100).floor
  #      end 
  #      ####################################################
  #      ####    END CALCULATE STATS
  #      ####################################################
  #
  #
  #      ########################
  #      ### AUTO-EXTEND 2 WEEKS IF MONITORING
  #      ###
  #      ### when a goal is monitored, 
  #      ### when someone checks in, 
  #      ### make sure the end date is at least 2-3 weeks away
  #      ### this way you'll rarely need to ask someone to extend
  #      ################################################
  #      if @checkpoint.goal.status == "monitor"
  #          if @checkpoint.goal.stop < (dnow + 14)
  #            @checkpoint.goal.stop = dnow + 21          
  #            @checkpoint.goal.save                
  #          end
  #      end
  #      ########################
  #      ### END AUTO-EXTEND 2 WEEKS IF MONITORING
  #      ########################
  #
  #
  #      ########################
  #      ### EXTEND AND MONITOR
  #      ########################
  #      if params[:extend_g]
  #        #set_stop_date(@checkpoint.goal.id, 1)
  #        @checkpoint.goal.status = "monitor" 
  #        @checkpoint.goal.stop = @checkpoint.goal.stop + 21          
  #        @checkpoint.goal.save
  #      end
  #      ########################
  #      ### END EXTEND AND MONITOR
  #      ########################
  #
  #  else
  #      redirect_to account_url
  #  end
  #  
  #
  #end
  
  # PUT /checkpoints/1
  # PUT /checkpoints/1.xml
  def update
    @checkpoint = Checkpoint.find(params[:id])

    respond_to do |format|
      if @checkpoint.update_attributes(params[:checkpoint])
        if session[:return_to_url]
          format.html {redirect_to(session[:return_to_url])}
          format.xml  { head :ok }
        else
          format.html {redirect_to("/goals")}
          format.xml  { head :ok }          
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @checkpoint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /checkpoints/1
  # DELETE /checkpoints/1.xml
  def destroy
    #@checkpoint = Checkpoint.find(params[:id])
    #if @checkpoint == nil
    #    redirect_to account_url
    #end
    #if @checkpoint.goal == nil
    #    redirect_to account_url
    #end
    #
    #@checkpoint.destroy
    #
    #respond_to do |format|
    #  format.html { redirect_to(checkpoints_url) }
    #  format.xml  { head :ok }
    #end
    
    ### disable calling this via routes
    redirect_to account_url
  end
end
