require 'active_record'
require 'date'
require 'logger'
class SendReminders < ActiveRecord::Base
  # This script emails reminders to people about their goals


  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/send_reminders.rb

    ### CRONJOB fields
    # t.string   "name"
    # t.datetime "started_at"
    # t.datetime "completed_at"
    # t.string   "metric_1_name"
    # t.integer  "metric_1_value"
    # t.string   "metric_2_name"
    # t.integer  "metric_2_value"
    # t.string   "metric_3_name"
    # t.integer  "metric_3_value"
    # t.boolean  "success"
    # t.boolean  "failure"
    # t.text     "notes"
    # t.string   "cron_entry_text"

  cronjob = Cronjob.new
  cronjob.name = "send_reminders.rb"
  cronjob.started_at = DateTime.now
  cronjob.notes = ""
  cronjob.save

  sent_counter = 0


  if `uname -n`.strip == 'adv.adventurino.com'
    #### HABITFORGE SETTINGS ON VPS
    testing = 0 #send emails to everyone as needed
    #testing = 1 #only send emails to "jurowski@gmail.com/jurowski@pediatrics.wisc.edu" as needed


    adjust_server_hour = 0 ### this server is listing its time as GMT -0600

    #send_emails = 0
    send_emails = 1
    
    test_user_id1 = "29103"
    test_user_id2 = "13383"
  elsif `uname -n`.strip == 'gns499aa.joyent.us'
    #### DEV SETTINGS ON HABITFORGE VPS
    #testing = 0 #send emails to everyone as needed
    testing = 1 #only send emails to "jurowski@gmail.com/jurowski@pediatrics.wisc.edu" as needed

    adjust_server_hour = -6 ### this server is listing its time as GMT -0000

    #send_emails = 0
    send_emails = 1

    test_user_id1 = "3"
    test_user_id2 = "3"
  else
    #### SETTINGS FOR DEV LAPTOP
    #testing = 0 #send emails to everyone as needed
    testing = 1 #only send emails to "jurowski@gmail.com/jurowski@pediatrics.wisc.edu" as needed


    adjust_server_hour = 0 ### this laptop is listing its time as GMT -0600

    #send_emails = 0
    send_emails = 1

    test_user_id1 = "44"
    test_user_id2 = "15706"
  end





  jump_forward_days = 0
  
  ## add 3600 seconds for each hour, so 14400 = 4 hours.... won't affect the day/date... just the hour, for time zone re-sending if failures occurred, you could move the hour forward or backward
  hours_to_jump = 0
  jump_forward_seconds = (hours_to_jump + adjust_server_hour) * 3600  
  
  retried_times = 0
  retried_times_limit = 50



  attempt_to_resend_failures = 0
  #attempt_to_resend_failures = 1  

  maxemails = 800
  puts "Max emails to send per hour = #{maxemails}"



  begin
    retried_times = retried_times + 1
    
    puts "start er up"


    ###################
    #### DATE FUNCTIONS 
    ###################


    user_conditions = ""
    if testing == 1 ### assuming adminuseremail of "jurowski@gmail.com" or "jurowski@pediatrics.wisc.edu"
      user_conditions = "id = '#{test_user_id1}' or id = '#{test_user_id2}'"
    else
      user_conditions = "update_number_active_goals > 0 and confirmed_address = '1'"
    end

    @users = User.find(:all, :conditions => user_conditions)
    for user in @users
      ###################
      #### DATE FUNCTIONS 
      ###################
      ### GET USER DATE and TIMENOW ###


      #Time.zone = user.time_zone
      #tnow = Time.zone.now + jump_forward_seconds #User time

      Time.zone = user.time_zone
      if Time.zone
        tnow = Time.zone.now + jump_forward_seconds #User time
      else
        tnow = Time.now + jump_forward_seconds
      end

      
      tnow_hour_temp = tnow - (0 * 3600) # add 3600 seconds for each hour, so 14400 = 4 hours
      tnow_hour = tnow_hour_temp.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)

      tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
      tnow_m = tnow.strftime("%m").to_i #month of the year
      tnow_d = tnow.strftime("%d").to_i #day of the month
      tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
      tnow_k = tnow.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
      tnow_M = tnow.strftime("%M").to_i #minute of the hour
      #puts tnow_Y + tnow_m + tnow_d  
      #puts "Current timestamp is #{tnow.to_s}"
      dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
      dyesterday = dnow - 1

      day_name = ""
      today_dayname = dnow.strftime("%A")
      #puts "Current timestamp is #{tnow.to_s}"
      #puts "Yesterday was a #{yesterday_dayname}"
      if today_dayname == "Monday"
          day_name = "daym"
      end
      if today_dayname == "Tuesday"
          day_name = "dayt"
      end
      if today_dayname == "Wednesday"
          day_name = "dayw"
      end
      if today_dayname == "Thursday"
          day_name = "dayr"
      end
      if today_dayname == "Friday"
          day_name = "dayf"
      end
      if today_dayname == "Saturday"
          day_name = "days"
      end
      if today_dayname == "Sunday"
          day_name = "dayn"
      end
      ######
      ###################
      ###################
      #@goals = Goal.find(:all, :conditions => "status !='hold' and start < '#{dnow}' and stop >= '#{dnow}' and #{day_name} = '1'") 
      goal_conditions = "user_id = #{user.id}"
      goal_conditions = goal_conditions + " and status != 'hold'"
      

      #goal_conditions = goal_conditions + " and ((start < '#{dnow}' and stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))"
      goal_conditions = goal_conditions + " and ((start <= '#{dnow}' and stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))"
      goal_conditions = goal_conditions + " and #{day_name} = '1'"   #comment out this one line if not supporting days of the week
      goal_conditions = goal_conditions + " and reminder_send_hour <= '#{tnow_hour}'"
      goal_conditions = goal_conditions + " and reminder_send_hour <> '-1'"
      goal_conditions = goal_conditions + " and (reminder_last_sent_date is null or reminder_last_sent_date < '#{dnow}')"
      #goal_conditions = goal_conditions + " and reminder_last_sent_date < '#{dnow}'"

      #don't send the reminder on the goal creation day!
      #so if user.today < goal.start_date, don't send

      #logtext = "running #{goal_conditions}"              
      #puts logtext
      #logger.info logtext 

      
      @goals = Goal.find(:all, :conditions => goal_conditions)
      for goal in @goals

        @checkpoints_at_least_one = Checkpoint.find(:all, :conditions => "goal_id = '#{goal.id}' and checkin_date = '#{dnow}'")
        @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal.id}' and checkin_date = '#{dnow}' and status = 'email not yet sent'")
        if !@checkpoints_at_least_one or @checkpoints.size > 0



          ### don't let a reminder go out if it's > 4 hours too late
          max_time_to_send = goal.reminder_send_hour + 4
          if tnow_hour <= max_time_to_send 

              ### Send reminder email
              logtext = "About to send user_id of #{goal.user.id.to_s} ( #{goal.user.email} ) a reminder email for today (#{today_dayname}), #{dnow}. Their time is #{tnow.to_s} or hour number #{tnow_hour}."              
              puts logtext
              logger.info logtext 

              reminder_sent = false
          
              if goal.user.sponsor == "habitforge"
                      begin
                          Notifier.deliver_daily_reminder_to_user(goal) # sends the email
                          logger.debug "reminder sent for " + goal.user.email + " " + goal.title
                          reminder_sent = true

                      rescue
                          the_message = "SGJerror failed to send HF reminder for goal " + goal.id.to_s + " entitled " + goal.title + " to " + goal.user.email 
                          puts the_message
                          logger.error the_message
                          cronjob.notes += "<br>" + the_message
                      end
              end
              if goal.user.sponsor == "forittobe"
                      begin
                          Notifier.deliver_daily_reminder_to_user_forittobe(goal) # sends the email 
                          logger.debug "reminder sent for " + goal.user.email + " " + goal.title
                          reminder_sent = true

                      rescue
                          the_message = "SGJerror failed to send FORITTOBE reminder to " + goal.user.email 
                          puts the_message
                          logger.error the_message
                      end
              end
              if goal.user.sponsor == "clearworth"
                      begin 
                          Notifier.deliver_daily_reminder_to_user_clearworth(goal) # sends the email 
                          logger.debug "reminder sent for " + goal.user.email + " " + goal.title
                          reminder_sent = true

                      rescue
                          the_message = "SGJerror failed to send CLEARWORTH reminder to " + goal.user.email 
                          puts the_message
                          logger.error the_message
                      end
              end
          
              if reminder_sent
                  sent_counter += 1
                  goal.reminder_last_sent_date = dnow
                  goal.save

                  logtext = "Success emailing #{goal.user.email}."              
                  puts logtext
                  logger.info logtext 
              end


          else
              ### it's too late in the day, don't bother sending this reminder
          end ### end whether too late in the day to send reminder


          
        end ## end whether we have a qualifying checkpoint

      end ### end for each goal
    end ### end for each user
    
    puts "end of script"
  rescue Timeout::Error
    puts "Timeout error on run number #{retried_times}... restarting script from the top"
    if retried_times < retried_times_limit
      retry
    end
  end


      ### CRONJOB fields
    # t.string   "name"
    # t.datetime "started_at"
    # t.datetime "completed_at"
    # t.string   "metric_1_name"
    # t.integer  "metric_1_value"
    # t.string   "metric_2_name"
    # t.integer  "metric_2_value"
    # t.string   "metric_3_name"
    # t.integer  "metric_3_value"
    # t.boolean  "success"
    # t.boolean  "failure"
    # t.text     "notes"
    # t.string   "cron_entry_text"

  cronjob.metric_1_name = "reminder emails sent"
  cronjob.metric_1_value = sent_counter

  cronjob.metric_2_name = "retried times"
  cronjob.metric_2_value = retried_times

  cronjob.completed_at = DateTime.now
  cronjob.save

end
