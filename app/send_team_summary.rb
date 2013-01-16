require 'active_record'
require 'date'
require 'logger'
class SendTeamSummary < ActiveRecord::Base
  # This script emails people with active goals who are on a team, a summary about their team's progress


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
      user_conditions = "update_number_active_goals > 0 and "
      user_conditions = user_conditions + "sponsor = 'habitforge'"
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
      goal_conditions = "user_id = #{user.id}"
      goal_conditions = goal_conditions + " and status != 'hold'"
      goal_conditions = goal_conditions + " and ((start <= '#{dnow}' and stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))"
      #goal_conditions = goal_conditions + " and #{day_name} = '1'"   #comment out this one line if not supporting days of the week
      goal_conditions = goal_conditions + " and team_summary_send_hour <= '#{tnow_hour}'"
      goal_conditions = goal_conditions + " and team_summary_send_hour <> '-1'"
      goal_conditions = goal_conditions + " and (team_summary_last_sent_date is null or team_summary_last_sent_date < '#{dnow}')"

      #don't send the reminder on the goal creation day!
      #so if user.today < goal.start_date, don't send

    #logtext = "running #{goal_conditions}"              
    #puts logtext
    #logger.info logtext 

      
      @goals = Goal.find(:all, :conditions => goal_conditions)
      for goal in @goals
	proceed = false
	if goal.is_part_of_a_team
	  team_goals = Goal.find(:all, :conditions => "team_id = '#{goal.team_id}'")
	  if team_goals.size > 1
            proceed = true
          end
	end

          
        ### don't let a reminder go out if it's > 4 hours too late
        max_time_to_send = goal.team_summary_send_hour + 4
        if proceed and tnow_hour <= max_time_to_send 

            ### Send team summary email
            logtext = "About to send user_id of #{goal.user.id.to_s} ( #{goal.user.email} ) a team summary email for today (#{today_dayname}), #{dnow}. Their time is #{tnow.to_s} or hour number #{tnow_hour}."              
            puts logtext
            logger.info logtext 

            team_summary_sent = false
        
                    begin
                        Notifier.deliver_daily_team_summary_to_user(goal) # sends the email
                        logger.debug "team summary sent for " + goal.user.email + " " + goal.title
                        team_summary_sent = true
                    rescue
			team_summary_sent = true ### doing this for now so that a glitch doesn't hold up everyone else's emails from being delivered
                        the_message = "SGJerror failed to send HF team summary for goal " + goal.id.to_s + " entitled " + goal.title + " to " + goal.user.email 
                        puts the_message
                        logger.error the_message
                    end

        
            if team_summary_sent
                goal.team_summary_last_sent_date = dnow
                goal.save

                logtext = "Success emailing team summary to #{goal.user.email}."              
                puts logtext
                logger.info logtext 
            end


        else
            ### it's too late in the day, don't bother sending this team_summary
        end

      end
    end
    
    puts "end of script"
  rescue Timeout::Error
    puts "Timeout error on run number #{retried_times}... restarting script from the top"
    if retried_times < retried_times_limit
      retry
    end
  end
end
