class GoalsController < ApplicationController
  require 'date'
  require 'logger'

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  include GoalsHelper
  include CoachgoalsHelper

  layout "application"

  ### see "applicatoin_controller.rb"...
  ### we can now allow pages ("index" and others) to be accessed w/out logging in as long as they have the
  ### goal_id, user id (as "u"), first letter of first name and first letter of email
  ### ex: URL params: &e0=<%= @goal.user.email[0] %>&f0=<%= @goal.user.first_name[0] %>
  
  before_filter :require_user, :only => [:single, :show, :new, :edit, :destroy, :update, :invite_a_friend_to_track]
  before_filter :require_user_unless_newly_paid, :only => [:index]
  autocomplete_for :goal, :response_question

  def get_dnow
    ### GET DATE NOW ###
    jump_forward_days = 0

    Time.zone = @goal.user.time_zone
    tnow = Time.zone.now
    
    #if current_user
    #  Time.zone = current_user.time_zone
    #  tnow = Time.zone.now #User time
    #else
    #  tnow = Time.now
    #end

    tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
    tnow_m = tnow.strftime("%m").to_i #month of the year
    tnow_d = tnow.strftime("%d").to_i #day of the month
    tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
    tnow_M = tnow.strftime("%M").to_i #minute of the hour
    #puts tnow_Y + tnow_m + tnow_d  
    #puts "Current timestamp is #{tnow.to_s}"
    dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
    ######
    return dnow
  end
  

  ### http://stackoverflow.com/questions/10539143/reloading-partial-in-an-rails-app
  # GET /goals/dynamic_latest_public_checkins
  def dynamic_latest_public_checkins

    render :partial => "goals/dynamic_latest_public_checkins"
  end

  # GET /goals/ads
  def dynamic_ads

    render :partial => "goals/dynamic_ads"
  end


  ### http://stackoverflow.com/questions/10539143/reloading-partial-in-an-rails-app
  # GET /goalss/catch_up_on_checkpoints
  def catch_up_on_checkpoints
    @goal = Goal.find(params[:goal_id].to_i)

    comment = ""
    if @goal.update_checkpoint(params[:date], params[:update_checkpoint_status], comment)
      flash[:notice] = 'Checkpoint Updated.'
    else
      logger.debug"SGJ error updating checkpoint"
      flash[:notice] = 'Error updating checkpoint.'
    end

    render :partial => "goals/catch_up_on_checkpoints", :locals => { :goal => @goal } 
  end



  # GET /goals
  # GET /goals.xml


  def index2
    #test index page
  end

  #def catch_up
  #
  #  ### test for ajax-loading of partial without prototype and newer javascript
  # render :partial => "goals/catch_up_on_checkpoints", :locals => { :catch_up_on_checkpoints => @goal }
  #end



  ### http://stackoverflow.com/questions/2499771/updating-a-rails-partial-with-ajax
  def js_update_checkpoint_yes
      respond_to do |format|
        #format.js{ render :update do |page|
        format.js{ render :index do |page|
          ### COMING FROM:
          ### link_to_remote 'YES-RJS2', :url => {:controller => "goals", :action => "js_update_checkpoint_yes"}, :locals => { :goal => @goal, :checkin_date => @checkin_date } %>
          @goal = Goal.find(params[:goal_id])
          @goal.update_checkpoint(params[:checkin_date], "yes", "")
          page.replace_html "goal_#{@goal.id}", :partial => "goals/catch_up_on_checkpoints"
        end}
      end
  end

  
  
  def index
    @show_autoupdatemultiple_personal_motivation = false
    @show_stats_lightbox = false

    @push_message_to_slacker_attempt = false
    @push_message_to_slacker_sent = false
 
   logger.debug "SGJ2 inside index"
    #if current_user
        ### see "applicatoin_controller.rb": this page is intended to be accessed via email URL:
        ### let user fake a login for one page, if they have enough correct info for coming in via email URL
        ### since there is no "current_user_session && current_user_session.record", it won't stay across requests        

        goal = Goal.new()
        @goal = Goal.new()
        @lightbox_goal = Goal.new()
        if params[:goal_id]
            goal = Goal.find(params[:goal_id].to_i)
            @goal = goal
        end
         
        ### If coming from an autoupdatemultiple screen
        if params[:coming_from] == "multiple" and session[:d]
            ### if any of today's answers are "no", then show personal motivation for those
            @goals_unsuccessful_needing_motivation = current_user.goals_unsuccessful_needing_personal_motivator_on_date(Date.parse(session[:d]))
            if !@goals_unsuccessful_needing_motivation.empty?
                @show_autoupdatemultiple_personal_motivation = true
            end
        end
        
        
        ### OLD MODE (AUTOUPDATE METHOD) http://localhost:3000/checkpoints/1080987/autoupdate?status=yes&return_to=goals&u=15706&g=25855
        ### NEW MODE EXAMPLE URL: http://localhost:3000/goals?update_checkpoint_status=no&date=2012-01-28&e0=106&f0=97&u=15706&goal_id=25855
        if params[:update_checkpoint_status] and params[:date] and params[:goal_id]
            if goal
                comment = ""
logger.debug "SGJ2 1 #{goal.title}(#{goal.id}) #{goal.daysstraight} daysstraight"
                if goal.update_checkpoint(params[:date], params[:update_checkpoint_status], comment)
logger.debug "SGJ2 2 #{goal.title}(#{goal.id}) #{goal.daysstraight} daysstraight"
                  flash[:notice] = 'Checkpoint Updated.'
                  if params[:coming_from] == "email"
                    @show_stats_lightbox = true
                    @lightbox_goal = goal
                  end
                else
                  logger.debug"SGJ error updating checkpoint"
                  flash[:notice] = 'Error updating checkpoint.'
                end
            else
              logger.debug"SGJ no such goal found to update checkpoint"
              flash[:notice] = 'No such goal found to update checkpoint.'
            end
        end

        if params[:update_comment] and params[:date] and params[:goal_id]
            if goal

                comment_id = "comment_" + goal.id.to_s
                comment = ""
                ### DO NOT PUT COLONS HERE
                if params[comment_id]
                    ### DO NOT PUT COLONS HERE
                    comment = params[comment_id]
                end
                if goal.update_checkpoint(params[:date], goal.get_daily_status_for(params[:date]), comment)
                  flash[:notice] = 'Comment Updated.'
                else
                  logger.debug"SGJ error updating comment"
                  flash[:notice] = 'Error updating comment.'
                end
            else
              logger.debug"SGJ no such goal found to update comment"
              flash[:notice] = 'No such goal found to update comment.'
            end
        end





        if params[:restart_goal_id]
            goal = Goal.find(params[:restart_goal_id].to_i)
            if goal
                if goal.restart_my_goal_at_day_1
                  flash[:notice] = 'Goal re-started at Day 1.'
                else
                  logger.debug"SGJ error re-starting goal #{goal.id}"
                  flash[:notice] = 'Error re-starting goal.'
                end
            else
              logger.debug"SGJ no such goal found to restart"
              flash[:notice] = 'No such goal found to restart.'
            end
        end

      if params[:join_a_team] and params[:goal_id]
        if goal
            if goal.join_goal_to_a_team
              flash[:notice] = 'Team joined successfully.'
            else
              logger.debug "SGJ error joining #{goal.id} to a team"
              flash[:notice] = 'Error joining a team.'
            end
        else
          logger.debug"SGJ no such goal found to add to a team"
          flash[:notice] = 'No such goal found to add to a team.'
        end
      end

      if params[:quit_a_team] and params[:goal_id]
        if goal
            goal.quit_a_team
        else
          logger.debug"SGJ no such goal found to quit team"
          flash[:notice] = 'No such goal found to quit team.'
        end
      end

      if params[:push_message_id] and params[:push_message_goal_id]
        ### don't let them send twice by hitting refresh and getting more points
        if !current_user.date_i_last_pushed_a_slacker or current_user.date_i_last_pushed_a_slacker < get_dnow
	  @push_message_to_slacker_attempt = true
	  begin
	        slacker_goal = Goal.find(params[:push_message_goal_id].to_i)
        	if slacker_goal and slacker_goal.allow_push and (slacker_goal.next_push_on_or_after_date and (slacker_goal.next_push_on_or_after_date == get_dnow) and (slacker_goal.pushes_remaining_on_next_push_date > 0))
          		if params[:push_message_id].to_i
                	  push_message_id = params[:push_message_id].to_i
                	  push_message = slacker_goal["phrase" + push_message_id.to_s]
                
                	  Notifier.deliver_pushmessage_to_slacker(current_user, slacker_goal.user, slacker_goal, push_message) # sends the email
			  @push_message_to_slacker_sent = true
 

			  slacker_goal.pushes_remaining_on_next_push_date -= 1
			  slacker_goal.save

			  current_user.date_i_last_pushed_a_slacker = get_dnow
			  current_user.slacker_id_that_i_last_pushed = slacker_goal.id

			  if !current_user.supportpoints
				current_user.supportpoints = 5
			  else
				current_user.supportpoints += 5
			  end

		          flash[:notice] = "You just earned 5 SupportPoints for pushing #{slacker_goal.user.first_name} to work on '#{slacker_goal.title}'!"	
	        	  
			  if !current_user.supportpoints_log
				current_user.supportpoints_log = ""
			  end
			  current_user.supportpoints_log += "\n" + flash[:notice]

			
          		  current_user.save

         		end
        	end
	  rescue
    		@push_message_to_slacker_sent = false
	  end
        end
      end


      if params[:optimize_my_first_goal]
       my_first_goal_id = 0
       if current_user.number_of_active_habits == 1
         my_first_goal_id = current_user.active_goals[0].id
       end 
       if my_first_goal_id != 0
          if params[:ga_goal] and params[:email]
           redirect_to("/goals/#{my_first_goal_id}/edit?ga_goal=#{params[:ga_goal]}&email=#{params[:email]}")
          else
           redirect_to("/goals/#{my_first_goal_id}/edit")
          end
       else
          if params[:ga_goal] and params[:email]
           redirect_to("/goals?ga_goal=#{params[:ga_goal]}&email=#{params[:email]}")
          else
           redirect_to("/goals")
          end
       end 
     else
          ### http://firstruby.wordpress.com/2008/11/03/remote_function-or-link_to_remote-with-multiple-parameters-in-ruby-on-rails/
          respond_to do |format|
            format.html # index.html.erb
            #format.xml  { render :xml => @goals }
            format.js # index.rjs
          end
      end

    #else
    #  redirect_to(server_root_url)
    #end
  end

  # GET /goals/1
  # GET /goals/1.xml
  def show
    ### Scoped properly
    
    #if current_user
      @goal = Goal.find(params[:id])
      if current_user.id != @goal.user.id
        redirect_to(server_root_url)        
      else
        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @goal }        
      end
      end
    #else
    #  redirect_to(server_root_url)
    #end
  end


  # GET /goals/new
  # GET /goals/new.xml
  def new


    ### not sure why this will not die so putting it here
    session[:goal_template_text] = nil

    ### If they are restricted to 1 active goal, redirect away
    restrict = false
    
    if current_user
      logger.info("sgj:fumfin:current_user.email = " + current_user.email)
      #logger.info("sgj:fumfin:!current_user.is_habitforge_supporting_member.to_s = " + !current_user.is_habitforge_supporting_member)
      if session[:site_name]
        logger.info("sgj:fumfin:session[:site_name] = " + session[:site_name].to_s)
      end
      if session[:sponsor]
        logger.info("sgj:fumfin:session[:sponsor] = " + session[:sponsor].to_s)
      end
      logger.info("sgj:fumfin:current_user.number_of_active_habits = " + current_user.number_of_active_habits.to_s)
    end ### end if current_user


    if (session[:site_name] == nil or session[:site_name] == "" or session[:sponsor] == "") or (session[:site_name] == "habitforge" or session[:sponsor] == "habitforge") and !current_user.is_habitforge_supporting_member
      logger.info("sgj:fumfin:got in 1")

      if current_user.number_of_active_habits > 0
          restrict = true
      end
      
    end

    if restrict == true
        if params[:goal_template_text]
          redirect_to("/goals?too_many_active_habits=1&goal_template_text=#{params[:goal_template_text]}")
        else
          redirect_to("/goals?too_many_active_habits=1")
        end
    else


      @goal = Goal.new
      @goal.reminder_time = DateTime.new(2009,1,1,0,0,0)

      @goal.daym = 1
      @goal.dayt = 1
      @goal.dayw = 1
      @goal.dayr = 1
      @goal.dayf = 1
      @goal.days = 1
      @goal.dayn = 1


      @goal.more_reminders_enabled = false
      @goal.more_reminders_start = 8
      @goal.more_reminders_end = 22
      @goal.more_reminders_every_n_hours = 4
      @goal.more_reminders_last_sent = 0


      @goal.publish = 1

      if params[:goal_template_text]
        session[:goal_template_text] = params[:goal_template_text]

        ### only restrict features initially
        ### and only redirect to sales page
        ### if they're not currently a premium member
        if !current_user.is_habitforge_supporting_member
          session[:sfm_virgin] = true
          if params[:existing_user]
            session[:existing_user] = true
          end
        end

      end

      if session[:goal_template_text]
          @goal.title = session[:goal_template_text]
          @goal.response_question = @goal.title
      end

      if params[:template_user_parent_goal_id]
        session[:template_user_parent_goal_id] = params[:template_user_parent_goal_id]
      end
      if session[:template_user_parent_goal_id]
        @goal.template_user_parent_goal_id = session[:template_user_parent_goal_id].to_i
      end

      if params[:goal_added_through_template_from_program_id]
        session[:goal_added_through_template_from_program_id] = params[:goal_added_through_template_from_program_id].to_i
      end
      if session[:goal_added_through_template_from_program_id]
        @goal.goal_added_through_template_from_program_id = session[:goal_added_through_template_from_program_id].to_i
      end



      if params[:category]
        session[:category] = params[:category]
      end
      if session[:category]
        @goal.category = session[:category]
      end

      if current_user.goal_temp != nil and current_user.goal_temp != ""
        @goal.response_question = current_user.goal_temp
      end


      #### if we are basing our goal on a template, then copy those values
      if params[:template_user_parent_goal_id]
        template_user_parent_goal = Goal.find(params[:template_user_parent_goal_id].to_i)
        if template_user_parent_goal
          @goal.template_user_parent_goal_id = template_user_parent_goal.id
          @goal.title = template_user_parent_goal.title
          @goal.response_question = template_user_parent_goal.response_question
          @goal.category = template_user_parent_goal.category
          @goal.reminder_time = template_user_parent_goal.reminder_time
          @goal.daym = template_user_parent_goal.daym
          @goal.dayt = template_user_parent_goal.dayt
          @goal.dayw = template_user_parent_goal.dayw
          @goal.dayr = template_user_parent_goal.dayr
          @goal.dayf = template_user_parent_goal.dayf
          @goal.days = template_user_parent_goal.days
          @goal.dayn = template_user_parent_goal.dayn
          @goal.goal_days_per_week = template_user_parent_goal.goal_days_per_week
          @goal.remind_me = template_user_parent_goal.remind_me
          @goal.reminder_send_hour = template_user_parent_goal.reminder_send_hour
          @goal.check_in_same_day = template_user_parent_goal.check_in_same_day
          @goal.usersendhour = template_user_parent_goal.usersendhour

          if params[:goal_added_through_template_from_program_id]
            goal_added_through_template_from_program = Program.find(params[:goal_added_through_template_from_program_id].to_i)
            if goal_added_through_template_from_program
              @goal.goal_added_through_template_from_program_id = goal_added_through_template_from_program.id
            end
          end


          ### do not save here, because if you do, all of the stuff in "def create" won't get applied
          #@goal.save
        end
      end


      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @goal }
      end
    end
  end

  # GET /goals/1/edit
  def edit
    ### Scoped properly
    @goal = Goal.find(params[:id])


    if @goal.more_reminders_enabled == nil
      @goal.more_reminders_enabled = false
    end
    if @goal.more_reminders_start == nil
      @goal.more_reminders_start = 8
    end
    if @goal.more_reminders_end == nil
      @goal.more_reminders_end = 22
    end
    if @goal.more_reminders_every_n_hours == nil
      @goal.more_reminders_every_n_hours = 4
    end
    if @goal.more_reminders_last_sent == nil
      @goal.more_reminders_last_sent = 0
    end

    if current_user.id != @goal.user.id
      redirect_to(server_root_url)        
    end


  end
  def invite_a_friend_to_track
    ### Scoped properly
      
    @goal = Goal.find(params[:id])
    if current_user.id != @goal.user.id
      redirect_to(server_root_url)        
    end
  end
  def shared
  end
  def view_goal_creation_email
    @goal = Goal.find(params[:id])
  end
  def single
    ### Scoped properly

    @goal = Goal.find(params[:id])
    if current_user.id != @goal.user.id
      redirect_to(server_root_url)        
    end

    ### OLD MODE (AUTOUPDATE METHOD) <a href="<%= server_root_url %>/checkpoints/<%= checkpoint.id %>/autoupdate?status=yes&return_to=goals&u=<%= checkpoint.goal.user.id %>&g=<%= checkpoint.goal.id %>&return_to_url=<%= request.request_uri %>">Change to Yes</a>
    ### NEW MODE EXAMPLE URL: http://localhost:3000/goals/single/25855?update_checkpoint_status=no&date=2012-01-28
    if params[:update_checkpoint_status] and params[:date]
        comment = ""
        if @goal.update_checkpoint(params[:date], params[:update_checkpoint_status], comment)
          flash[:notice] = 'Checkpoint Updated.'
        else
          logger.debug"SGJ error updating checkpoint"
          flash[:notice] = 'Error updating checkpoint.'
        end
    end

    #if params[:update_comment] and params[:date]
    #    comment_id = "comment_" + @goal.id.to_s
    #    comment = ""
    #    ### DO NOT PUT COLONS HERE
    #    if params[comment_id]
    #        ### DO NOT PUT COLONS HERE
    #        comment = params[comment_id]
    #    end
    #    if @goal.update_checkpoint(params[:date], @goal.get_daily_status_for(params[:date]), comment)
    #      flash[:notice] = 'Comment Updated.'
    #    else
    #      logger.debug"SGJ error updating comment"
    #      flash[:notice] = 'Error updating comment.'
    #    end
    #end


      ### http://firstruby.wordpress.com/2008/11/03/remote_function-or-link_to_remote-with-multiple-parameters-in-ruby-on-rails/
      respond_to do |format|
        format.html # index.html.erb
        #format.js # single.rjs
      end

  end

  def sharelinks
  end

  # POST /goals
  # POST /goals.xml
  def create
      @show_sales_overlay = false

      if current_user and params[:first_name]
	        current_user.first_name = params[:first_name]
 
          ### having periods in the first name kills the attempts to email that person, so remove periods
          current_user.first_name = current_user.first_name.gsub(".", "")
          current_user.save
      end 

      @goal = Goal.new(params[:goal])

      if @goal.template_owner_is_a_template
        @goal.status = "hold"
      end

      @goal.title = @goal.response_question

      if !@goal.pushes_allowed_per_day
        @goal.pushes_allowed_per_day = 1
      end    

      ################################
      #Status Creation Business Rules
      ################################
      #start      (create the goal starting today stopping after goal.days_to_form_a_habit days)
      #monitor  (create the goal starting today stopping after goal.days_to_form_a_habit days)
      #hold  (just create the goal and a default dummy date of 1/1/1900 for start and stop)
    
      respond_to do |format|
        if @goal.save

          if @goal.template_owner_is_a_template
            flash[:notice] = 'Template was successfully created.'

            ### if this new template was created to be part of an existing program
            if params[:program_id]
              program_template = ProgramTemplate.new()
              program_template.program_id = params[:program_id].to_i
              program_template.template_goal_id = @goal.id
              program_template.save
            end

          else
            flash[:notice] = 'Goal was successfully created.'


            ### update last activity date
            @goal.user.last_activity_date = @goal.user.dtoday
            @goal.user.save
     
            ###############################################
            ###### START IF SFM_VIRGIN
            if session[:sfm_virgin] and session[:sfm_virgin] == true
              session[:sfm_virgin] = false
              @show_sales_overlay = true

              @user = current_user

              ### existing_user will be true if coming from an infusionsoft email invite
              ### in that case, do not send them another welcome email
              if !session[:existing_user]
                #### now that we have their first name, we can send the email 
                the_subject = "Confirm your HabitForge Subscription"
                begin
                  #if Rails.env.production?
                    logger.error("sgj:goals_controller:about to send user confirmation to user " + @user.email)
                    Notifier.deliver_user_confirm(@user, the_subject) # sends the email
                  #end
                rescue
                  logger.error("sgj:email confirmation for user creation did not send")
                end
              end


              begin
                 #####################################################
                 #####################################################
                  #### UPDATE THE CONTACT FOR THEM IN INFUSIONSOFT ######
                  ### SANDBOX GROUP/TAG IDS
                  #112: hf new signup funnel v2 free no goal yet
                  #120: hf new signup funnel v2 free created goal
                  #
                  ### PRODUCTION GROUP/TAG IDS
                  #400: hf new signup funnel v2 free no goal yet
                  #398: hf new signup funnel v2 free created goal
                  if Rails.env.production?
                    Infusionsoft.contact_update(session[:infusionsoft_contact_id].to_i, {:FirstName => current_user.first_name, :LastName => current_user.last_name})
                    Infusionsoft.contact_add_to_group(session[:infusionsoft_contact_id].to_i, 398)
                    Infusionsoft.contact_remove_from_group(session[:infusionsoft_contact_id].to_i, 400)
                  end
                  ####          END INFUSIONSOFT CONTACT           ####
                  #####################################################
                  #####################################################
              rescue
                logger.error("sgj:error updating contact in infusionsoft")
              end
            end    ### END IF SFM_VIRGIN
            ###### END IF SFM_VIRGIN
            ###############################################


            current_user.goal_temp = ""
            current_user.save
          end ### end if goal != a template

        
          if @goal.usersendhour == nil
	          @goal.usersendhour = 1
          end

          Time.zone = @goal.user.time_zone
          utcoffset = Time.zone.formatted_offset(false)
          offset_seconds = Time.zone.now.gmt_offset 
          send_time = Time.utc(2000, "jan", 1, @goal.usersendhour, 0, 0) #2000-01-01 01:00:00 UTC
          central_time_offset = 21600 #add this in since we're doing UTC
          server_time = send_time - offset_seconds - central_time_offset
          puts "User lives in #{@goal.user.time_zone} timezone, UTC offset of #{utcoffset} (#{offset_seconds} seconds)." #Save this value in each goal, and use that to do checkpoint searches w/ cronjob
          puts "For them to get an email at #{send_time.strftime('%k')} their time, the server would have to send it at #{server_time.strftime('%k')} Central time"
          @goal.serversendhour = server_time.strftime('%k')
          @goal.gmtoffset = utcoffset          
          #############
          
          

          if @goal.daym == nil 
            @goal.daym = true
          end
          if @goal.dayt == nil 
            @goal.dayt = true
          end
          if @goal.dayw == nil 
            @goal.dayw = true
          end
          if @goal.dayr == nil 
            @goal.dayr = true
          end
          if @goal.dayf == nil 
            @goal.dayf = true
          end
          if @goal.days == nil 
            @goal.days = true
          end
          if @goal.dayn == nil 
            @goal.dayn = true
          end

          if !@goal.template_owner_is_a_template
            if @goal.status != "hold" and @goal.daym and @goal.dayt and @goal.dayw and @goal.dayr and @goal.dayf and @goal.days and @goal.dayn and (@goal.goal_days_per_week == nil or @goal.goal_days_per_week == 7)
              @goal.status = "start"
            else
              @goal.status = "monitor"
            end
          end


          #########
          ### Once the goal is saved, set the start and stop dates

          
          dnow = get_dnow

          if @goal.status == "hold"
            @goal.start = Date.new(1900, 1, 1)
            @goal.stop = @goal.start 
          end
          @goal.established_on = Date.new(1900, 1, 1)
          if (@goal.status == "start" or @goal.status == "monitor")
            start_day_offset = 1
            if params[:delay_start_for_this_many_days] 
              start_day_offset = params[:delay_start_for_this_many_days].to_i
            end
            ### Set the standard dates
            @goal.start = dnow + start_day_offset
            @goal.stop = @goal.start + @goal.days_to_form_a_habit
      	    @goal.first_start_date = @goal.start          
            @goal.save
          end


          ### save date changes
          @goal.save


          ### we don't need/want these anymore
          ### destroy them so that they don't mess up a future new goal
          session[:goal_added_through_template_from_program_id] = nil
          session[:template_user_parent_goal_id] = nil
          session[:goal_template_text] = nil
          session[:category] = nil


        
          if @goal.status == "hold"
            ### don't send an email if it's on hold
          else
            begin              
              if session[:sponsor] == "clearworth"
                #Notifier.deliver_goal_creation_notification_clearworth(@goal) # sends the email
              elsif session[:sponsor] == "forittobe"
                #Notifier.deliver_goal_creation_notification_forittobe(@goal) # sends the email
              elsif session[:sponsor] == "marriagereminders"
                #Notifier.deliver_goal_creation_notification_marriagereminders(@goal) # sends the email
              else
                #Notifier.deliver_goal_creation_notification(@goal) # sends the email
              end
            rescue
              puts "Error while sending goal notification email from Goal.create action."
            end
          end



          ### if this new template was created to be part of an existing program
          if params[:program_id]
            format.html {redirect_to("/programs/#{params[:program_id]}")}
          else

            begin 
              ### attempt to add to encourage_items


              # when a goal is created,
              # if username != unknown,
              # if the goal is public,
              # then enter it into encourage_items

              # --- encourage_item ---
              # encourage_type_new_checkpoint_bool (index)
              # encourage_type_new_goal_bool (index)
              # checkpoint_id
              # checkpoint_status
              # checkpoint_date (index)
              # checkpoint_updated_at_datetime
              # goal_id (index)
              # goal_name
              # goal_category
              # goal_created_at_datetime
              # goal_publish
              # goal_first_start_date (index)
              # goal_daysstraight
              # goal_days_into_it
              # goal_success_rate_percentage
              # user_id (index)
              # user_name
              # user_email

              logger.debug "sgj:goals_controller.rb:consider adding to encourage_items"
              if @goal.user.first_name != "unknown"
                if @goal.is_public
                  logger.debug "sgj:goals_controller.rb:candidate for encourage_items"

                  encourage_item = EncourageItem.new
                  logger.debug "sgj:goals_controller.rb:new encourage_items instantiated"

                  encourage_item.encourage_type_new_checkpoint_bool = false
                  encourage_item.encourage_type_new_goal_bool = true

                  #encourage_item.checkpoint_id = nil
                  encourage_item.checkpoint_id = @goal.id ### a workaround to the validation that checkpoint_id is unique

                  encourage_item.checkpoint_status = nil
                  encourage_item.checkpoint_date = nil
                  encourage_item.checkpoint_updated_at_datetime = nil
                  encourage_item.goal_id = @goal.id
                  encourage_item.goal_name = @goal.title
                  encourage_item.goal_category = @goal.category
                  encourage_item.goal_created_at_datetime = @goal.created_at
                  encourage_item.goal_publish = @goal.publish
                  encourage_item.goal_first_start_date = @goal.first_start_date
                  encourage_item.goal_daysstraight = @goal.daysstraight
                  encourage_item.goal_days_into_it = @goal.days_into_it
                  encourage_item.goal_success_rate_percentage = @goal.success_rate_percentage
                  encourage_item.user_id = @goal.user.id
                  encourage_item.user_name = @goal.user.first_name
                  encourage_item.user_email = @goal.user.email

                  logger.debug "sgj:goals_controller.rb:about to save encourage_items"

                  if encourage_item.save
                    logger.info("sgj:goals_controller.rb:success saving encourage_item")
                  else
                    logger.error("sgj:goals_controller.rb:error saving encourage_item")
                  end
                  logger.debug "sgj:goals_controller.rb:new encourage_item.id = " + encourage_item.id.to_s

                end
              end

            rescue
             logger.error "sgj:error adding to encourage_items"
            end


            if @show_sales_overlay
              ### format.html { render :action => "edit" }

              if Rails.env.production?

                ### show the sales page and eventually kick back to optimize when they cancel
                #format.html {redirect_to("https://www.securepublications.com/habit-gse3.php?ref=#{current_user.id.to_s}&email=#{current_user.email}")}

                ### do not show the sales page first, just kick to optimize
                format.html {redirect_to("/goals?optimize_my_first_goal=1&email=#{current_user.email}&single_login=1")}

              else
                session[:dev_mode_just_returned_from_sales_page] = true
                format.html {redirect_to("/goals?optimize_my_first_goal=1&email=#{current_user.email}&single_login=1")}
              end

              format.xml  { render :xml => @goals }
            else
              format.html { render :action => "index" } # index.html.erb
              format.xml  { render :xml => @goals }
            end

          end          



          

        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @goal.errors, :status => :unprocessable_entity }
        end
      end
  end

  def extend_time
    @goal = Goal.find(params[:id])
    
    #############
    #### determine if someone is trying to do something naughty... if so, go back to home page
    redirect_away = 0
    if current_user == nil
      puts "@goal.user.id = " + @goal.user.id.to_s
      if params[:u]
        puts "params[:u] = " + params[:u]
        if params[:u] != @goal.user.id.to_s
          ## wrong user for this goal
          redirect_away = 1      
        end
      else
        ### no user in params either
        redirect_away = 1      
      end
    else
      if current_user.id != @goal.user.id
        redirect_away = 1      
      end      
    end
    if redirect_away == 1      
      redirect_to(server_root_url)        
    end
    ##############    
    
    #set_stop_date(@goal.id, 1)

    @goal.stop = @goal.stop + @goal.days_to_form_a_habit

    @goal.status = "monitor" 
    @goal.save

    ### update last activity date
    @goal.user.last_activity_date = @goal.user.dtoday
    @goal.user.save

    #redirect_to(goals_url)      
  end
  
  def hold
    ### Scoped properly

    @goal = Goal.find(params[:id])

    #############
    #### determine if someone is trying to do something naughty... if so, go back to home page
    redirect_away = 0
    if current_user == nil
      puts "@goal.user.id = " + @goal.user.id.to_s
      if params[:u]
        puts "params[:u] = " + params[:u]
        if params[:u] != @goal.user.id.to_s
          ## wrong user for this goal
          redirect_away = 1      
        end
      else
        ### no user in params either
        redirect_away = 1      
      end
    else
      if current_user.id != @goal.user.id
        redirect_away = 1      
      end      
    end
    if redirect_away == 1      
      redirect_to(server_root_url)        
    end
    ##############
    
    
    flash[:notice] = 'This goal is being put on hold. Email checkpoints will no longer be sent for this goal.'
    
    @goal.status = "hold"
    @goal.start = Date.new(1900, 1, 1)
    @goal.stop = @goal.start 
    @goal.save    
    #redirect_to(goals_url)
  end
  def go
    ### Scoped properly

    @goal = Goal.find(params[:id])
    if current_user.id != @goal.user.id
      redirect_to(server_root_url)        
    else
      @goal.status = "start"
      @goal.save

      #########
      ### Once the goal is saved, set the start and stop dates

      dnow = get_dnow

      @goal.established_on = Date.new(1900, 1, 1)

      @goal.start = dnow
      @goal.stop = @goal.start + @goal.days_to_form_a_habit

      #set_start_date(@goal.id, dnow)
      #set_stop_date(@goal.id, 0)


      @goal.save


      ### update last activity date
      @goal.user.last_activity_date = @goal.user.dtoday
      @goal.user.save

      redirect_to(goals_url)
    end
  end
  
  # PUT /goals/1
  # PUT /goals/1.xml
  def update
    ### Scoped properly

      @goal = Goal.find(params[:id])

 

      if !@goal.pushes_allowed_per_day
        @goal.pushes_allowed_per_day = 1
      end
 
      
      if current_user.id != @goal.user.id
        redirect_to(server_root_url)        
      else    
        ################################
        #Status Change Business Rules
        ################################

        # Theory: keep past data that's relevant for later analysis

        ##start --> hold      
        ##monitor --> hold
        # 1) (keep any past/non-default checkpoints for future stats)

        #start --> monitor 
        #hold --> monitor
        #monitor --> start
        #hold --> start
        # 1) (remove all existing checkpoints (as of 20110913))
        # 2) (set goal.start to today, stopping after goal.days_to_form_a_habit days)

        old_status = @goal.status

        old_publish = @goal.publish
                
    
        respond_to do |format|
          if @goal.update_attributes(params[:goal])



              
            ### update last activity date
            @goal.user.last_activity_date = @goal.user.dtoday
            @goal.user.save
            
            @goal.title = @goal.response_question

            
            ##### SET THE HOUR THAT THE REMINDERS SHOULD GO OUT FOR THIS GOAL #############
              if @goal.usersendhour == nil
	             @goal.usersendhour = 1
              end

            Time.zone = @goal.user.time_zone
            utcoffset = Time.zone.formatted_offset(false)
            offset_seconds = Time.zone.now.gmt_offset 
            send_time = Time.utc(2000, "jan", 1, @goal.usersendhour, 0, 0) #2000-01-01 01:00:00 UTC
            central_time_offset = 21600 #add this in since we're doing UTC
            server_time = send_time - offset_seconds - central_time_offset
            puts "User lives in #{@goal.user.time_zone} timezone, UTC offset of #{utcoffset} (#{offset_seconds} seconds)." #Save this value in each goal, and use that to do checkpoint searches w/ cronjob
            puts "For them to get an email at #{send_time.strftime('%k')} their time, the server would have to send it at #{server_time.strftime('%k')} Central time"            
            @goal.serversendhour = server_time.strftime('%k')
            @goal.gmtoffset = utcoffset

            #############


            if @goal.daym == nil 
              @goal.daym = true
            end
            if @goal.dayt == nil 
              @goal.dayt = true
            end
            if @goal.dayw == nil 
              @goal.dayw = true
            end
            if @goal.dayr == nil 
              @goal.dayr = true
            end
            if @goal.dayf == nil 
              @goal.dayf = true
            end
            if @goal.days == nil 
              @goal.days = true
            end
            if @goal.dayn == nil 
              @goal.dayn = true
            end

            if @goal.template_owner_is_a_template
              @goal.save            
              flash[:notice] = 'Template was successfully updated.'
              logger.info 'SGJ Template was successfully updated.'
            else
              if @goal.status != "hold" and @goal.daym and @goal.dayt and @goal.dayw and @goal.dayr and @goal.dayf and @goal.days and @goal.dayn and (@goal.goal_days_per_week == nil or @goal.goal_days_per_week == 7)
                @goal.status = "start"
              else
                @goal.status = "monitor"
              end
              @goal.save            
              flash[:notice] = 'Goal was successfully updated.'
              logger.info 'SGJ Goal was successfully updated.'
            end





            dnow = get_dnow
          
            logger.debug 'old_status =' + old_status
            logger.debug 'new status =' + @goal.status
            ##If status was changed to start or monitor, delete and re-create future checkpoints
            if old_status != @goal.status
              if (@goal.status == "start" or @goal.status == "monitor")       
                #set_start_date(@goal.id, dnow)
                #set_stop_date(@goal.id, 0)
                @goal.start = dnow
                @goal.stop = @goal.start + @goal.days_to_form_a_habit

                ################################################################################################
                ####  If someone is switching a goal from a "monitor" goal over to a "start" goal,
                ####  then make sure all days-of-the week get saved as "checked", 
                ####  otherwise it won't create their checkpoints, and it will end their start date prematurely.
                if @goal.status == "start"
                    @goal.daym = true
                    @goal.dayt = true
                    @goal.dayw = true
                    @goal.dayr = true
                    @goal.dayf = true
                    @goal.days = true
                    @goal.dayn = true
                end
                ################################################################################################
                ################################################################################################      
                
                ############################
                ### If someone is going from "hold" to "re-activate"
                ### delete the old checkpoints because keeping them messes up the success rate
                ### they have been warned of this happening already
                #if old_status == "hold"
                #    ### Re-set days straight to 0
                #    @goal.daysstraight = 0
                #    
                #    ### Destroy any associated Checkpoints
                #    @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{@goal.id}'")
                #    for checkpoint in @checkpoints
                #      checkpoint.destroy
                #   end                    
                #end          
                ############################
                ############################

              end
              if @goal.status == "hold"
                @goal.start = Date.new(1900, 1, 1)
                @goal.stop = @goal.start 
              end
              ### save date changes
              @goal.save


              #format.html { render :action => "index" } # index.html.erb
              #format.xml  { render :xml => @goals }
            end


            ### when a goal is saved by user, if it's "private", remove any entries from "encourage_items"
            if @goal.publish == false and old_publish == true
              logger.info("sgj:goals_controller.rb:about to remove entries because publish status changing")
              encourage_items = EncourageItem.find(:all, :conditions => "goal_id = '#{@goal.id}'")
              encourage_items.each do |e|
                e.destroy
              end
            end


            if @goal.template_owner_is_a_template
              flash[:notice] = 'Template was successfully updated.' + flash[:notice]
            else
              flash[:notice] = 'Goal was successfully updated.' + flash[:notice]
            end


            format.html { render :action => "index" } # index.html.erb
            format.xml  { render :xml => @goal.errors, :status => :unprocessable_entity }            
          end
        end
      end
  end

  # DELETE /goals/1
  # DELETE /goals/1.xml
  def destroy
    ### Scoped properly

      @goal = Goal.find(params[:id])
      if current_user.id != @goal.user.id
        redirect_to(server_root_url)        
      else



        ### Destroy any associated Team memberships (aka teamgoals)
        if @goal.team_id != nil
            team = Team.find(:first, :conditions => "id = '#{@goal.team_id}'")            
            if team
                ### Modify teamgoal record
                teamgoal = Teamgoal.find(:first, :conditions => "goal_id = '#{@goal.id}' and team_id = '#{@goal.team_id}'")
                if teamgoal
                    teamgoal.destroy
                end
                ### Modify and Save Team
                team.qty_current = team.qty_current - 1 
                if team.qty_current < 0
                    team.qty_current = 0
                end 
                if team.qty_current >= team.qty_max
                    team.has_opening = 0
                else
                    team.has_opening = 1
                end
                team.save  
            end  
        end


        ### Destroy any associated Checkpoints
        @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{params[:id]}'")
        for checkpoint in @checkpoints
          checkpoint.destroy
        end

        ### Destroy any associated Cheers
        @cheers = Cheer.find(:all, :conditions => "goal_id = '#{params[:id]}'")
        for cheer in @cheers
          cheer.destroy
        end

        @goal.destroy


        respond_to do |format|
          format.html { redirect_to(goals_url) }
          format.xml  { head :ok }
        end
      end
  end
    
end
