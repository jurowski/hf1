require 'active_record'
require 'date'
require 'logger'
class SendCheckpointEmails < ActiveRecord::Base



  # This script emails people who have checkins due on their goals


  if `uname -n`.strip == 'adv.adventurino.com'
    #### HABITFORGE SETTINGS ON VPS
    #testing = 0 #send emails to everyone as needed
    testing = 1 #only send emails to "jurowski@gmail.com/jurowski@pediatrics.wisc.edu" as needed


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
    test_user_id2 = "83430"
  end





  jump_forward_days = 0
  
  ## add 3600 seconds for each hour, so 14400 = 4 hours.... won't affect the day/date... just the hour, for time zone re-sending if failures occurred, you could move the hour forward or backward
  hours_to_jump = 0
 # hours_to_jump = -5

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
    FileUtils.touch 'launched_update_stats_at'


    
    if retried_times == 1
      create_checkpoints = 1
    else
      create_checkpoints = 0
    end
    


    ###################
    #### DATE FUNCTIONS 
    ###################
    ### GET SERVER DATE AND TIME NOW ###

    #### THIS IS SERVER DATE/TIME FOR USE W/STATS... DON'T WANT USER TIME
    #Time.zone = current_user.time_zone
    #tnow = Time.zone.now #User time
    
    tnow = Time.now + jump_forward_seconds

    tlimit1 = tnow - (1 * 3600) # add 3600 seconds for each hour, so 14400 = 4 hours
    tlimit2 = tnow - (2 * 3600)
    tlimit3 = tnow - (3 * 3600)
    tlimit4 = tnow - (4 * 3600)
    tlimit5 = tnow - (5 * 3600)
    tlimit6 = tnow - (6 * 3600)
    tlimit7 = tnow - (7 * 3600)
    tlimit8 = tnow - (8 * 3600)
    #tlimit9 = tnow - (9 * 3600)

    tlimit1_k = tlimit1.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
    tlimit2_k = tlimit2.strftime("%k").to_i
    tlimit3_k = tlimit3.strftime("%k").to_i
    tlimit4_k = tlimit4.strftime("%k").to_i
    tlimit5_k = tlimit5.strftime("%k").to_i
    tlimit6_k = tlimit6.strftime("%k").to_i
    tlimit7_k = tlimit7.strftime("%k").to_i
    tlimit8_k = tlimit8.strftime("%k").to_i
    #tlimit9_k = tlimit9.strftime("%k").to_i
    
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
    d2daysago = dnow - 2
    dtomorrow = dnow + 1
    dtomorrow_plus1 = dtomorrow + 1

    tservernow = tnow
    ######
    ###################
    ###################



    ############################
    ### GET EMAIL PER HOUR STATS
    ############################
    #stat recorddate:date recordhour:integer usercount:integer goalcount:integer goalactivecount:integer goalsnewcreated:integer usersnewcreated:integer checkpointemailssent:integer
    @stats = Stat.find(:all, :conditions => "recorddate = '#{dnow}' and recordhour = '#{tnow_H}'")
    @stat = Stat.new
    if @stats.size > 0
      for stat in @stats
        @stat =  stat
      end
    else
      @stat.recorddate = dnow
      @stat.recordhour = tnow_H  
    end  
    ### too much of a memory hog
    #@all_users = User.find(:all)
    #@all_goals = Goal.find(:all)
    @failures = Checkpoint.find(:all, :conditions => "status = 'email failure'") 
    #@stat.goalcount = @all_goals.size
    ##@stat.usercount = @all_users.size
    @stat.totalheckpointemailfailure = @failures.size
    puts "There are #{@failures.size} failures so far today."
    if attempt_to_resend_failures == 0
      puts "Not going to attempt resending failures, even if there's time to do so."
    else
      puts "Will attempt resending failures, only if there's room to do so."    
    end 
    if @stat.checkpointemailssent == nil
      @stat.checkpointemailssent = 0
    end
    @stat.save
    puts "#{@stat.checkpointemailssent} emails sent this hour"
    ############################
    ############################



    ######################################################################################    
    ######################################################################################
    ######################################################################################
    ######################################################################################
    ######################################################################################
    #####     START CREATE CHECKPOINTS
    ######################################################################################
    ######################################################################################
    ######################################################################################
    ######################################################################################
    ######################################################################################
    user_conditions = ""
    if testing == 1 ### assuming adminuseremail of "jurowski@gmail.com" or "jurowski@pediatrics.wisc.edu"
      user_conditions = "id = '#{test_user_id1}' or id = '#{test_user_id2}'"
    else
      user_conditions = "update_number_active_goals > 0"
    end

    @users = User.find(:all, :conditions => user_conditions)
    for user in @users
      ###################
      #### DATE FUNCTIONS 
      ###################
      ### GET USER DATE and TIMENOW ###


      Time.zone = user.time_zone
      
      if Time.zone
        tnow = Time.zone.now + jump_forward_seconds #User time
      else
        tnow = Time.now + jump_forward_seconds
      end
      tlimit1 = tnow - (1 * 3600) # add 3600 seconds for each hour, so 14400 = 4 hours
      tlimit2 = tnow - (2 * 3600)
      tlimit3 = tnow - (3 * 3600)
      tlimit4 = tnow - (4 * 3600)
      tlimit5 = tnow - (5 * 3600)
      tlimit6 = tnow - (6 * 3600)
      tlimit7 = tnow - (7 * 3600)
      tlimit8 = tnow - (8 * 3600)
      #tlimit9 = tnow - (9 * 3600)


      tlimit1_k = tlimit1.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
      tlimit2_k = tlimit2.strftime("%k").to_i
      tlimit3_k = tlimit3.strftime("%k").to_i
      tlimit4_k = tlimit4.strftime("%k").to_i
      tlimit5_k = tlimit5.strftime("%k").to_i
      tlimit6_k = tlimit6.strftime("%k").to_i
      tlimit7_k = tlimit7.strftime("%k").to_i
      tlimit8_k = tlimit8.strftime("%k").to_i
      #tlimit9_k = tlimit9.strftime("%k").to_i
      
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
      d2daysago = dnow - 2
      dtomorrow = dnow + 1
      dtomorrow_plus1 = dtomorrow + 1


      day_name = ""
      day_name_plus1 = ""
      yesterday_dayname = dyesterday.strftime("%A")
      today_dayname = dnow.strftime("%A")
      #puts "Current timestamp is #{tnow.to_s}"
      #puts "Yesterday was a #{yesterday_dayname}"
      if yesterday_dayname == "Monday"
          ###create the checkpoint and send the email       
          day_name = "daym"
          day_name_plus1 = "dayt"
      end
      if yesterday_dayname == "Tuesday"
          ###create the checkpoint and send the email       
          day_name = "dayt"
          day_name_plus1 = "dayw"
      end
      if yesterday_dayname == "Wednesday"
          ###create the checkpoint and send the email       
          day_name = "dayw"
          day_name_plus1 = "dayr"
      end
      if yesterday_dayname == "Thursday"
          ###create the checkpoint and send the email       
          day_name = "dayr"
          day_name_plus1 = "dayf"
      end
      if yesterday_dayname == "Friday"
          ###create the checkpoint and send the email       
          day_name = "dayf"
          day_name_plus1 = "days"
      end
      if yesterday_dayname == "Saturday"
          ###create the checkpoint and send the email       
          day_name = "days"
          day_name_plus1 = "dayn"
      end
      if yesterday_dayname == "Sunday"
          ###create the checkpoint and send the email       
          day_name = "dayn"
          day_name_plus1 = "daym"
      end
      ######
      ###################
      ###################
      #@goals = Goal.find(:all, :conditions => "status !='hold' and start < '#{dnow}' and stop >= '#{dnow}' and #{day_name} = '1'") 
      goal_conditions = "user_id = #{user.id}"
      goal_conditions = goal_conditions + " and status != 'hold'"

      ### previous day check-ins
      #goal_conditions = goal_conditions + " and ((start < '#{dnow}' and stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))"

      ### same-day check-ins
      goal_conditions = goal_conditions + " and ((start <= '#{dnow}' and stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))"


      ### VERSION THAT IS FOR "previous day check-ins":
      #goal_conditions = goal_conditions + " and #{day_name} = '1'"   #comment out this one line if not supporting days of the week

      ### VERSION THAT IS FOR "same day check-ins":
      goal_conditions = goal_conditions + " and #{day_name_plus1} = '1'"   #comment out this one line if not supporting days of the week


      #goal_conditions = goal_conditions + " and ("
      #goal_conditions = goal_conditions + "usersendhour >= '#{tnow_k}'"      
      #goal_conditions = goal_conditions + "usersendhour = '#{tnow_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit1_k}'"
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit2_k}'"
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit3_k}'"           
      #goal_conditions = goal_conditions + ")"
      
      @goals = Goal.find(:all, :conditions => goal_conditions)
      for goal in @goals
        ###################
        ###################
        ### CREATE ALL CHECKPOINTS FIRST FOR THIS USER's Matching Goals
        ### (so that people can manually update their status if emails aren't going out)
        ###################
        ###################
        if create_checkpoints == 1


	  ### previous-day check-ins
          #checkin_date = dyesterday

	  ### same-day check-ins
	  checkin_date = dnow

          #if goal.gmtoffset == nil
          #  goal.gmtoffset = '-0500'
          #  goal.save
          #end 
       
          @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal.id}' and checkin_date = '#{checkin_date}'")
          if @checkpoints.size == 0
            #### START CREATE CHECK POINT
            checkpoint = Checkpoint.new
            checkpoint.goal_id = goal.id
            checkpoint.checkin_date = checkin_date
            checkpoint.status = "email not yet sent"
            if checkpoint.save
              #puts "SUCCESS creating checkpoint for #{goal.id} on #{checkin_date}"
              logtext = "#{checkpoint.goal.user.email} gets a checkpoint for #{today_dayname}, #{checkin_date}. Their time is #{tnow.to_s}. Server time is #{tservernow.to_s}."              
              puts logtext
              logger.info logtext 
            else
              puts "ERROR creating checkpoint for #{goal.id} on #{checkin_date}"        
            end
            #### END CREATE CHECKPOINT
          end    
        end
        ###################
        ### DONE CREATING ALL CHECKPOINTS FOR THIS USER
        ###################
      end
    end
    ######################################################################################
    ######################################################################################
    #####     END CREATE CHECKPOINTS
    ######################################################################################
    ######################################################################################
    ######################################################################################
    ######################################################################################







    ######################################################################################
    ######################################################################################
    ######################################################################################
    ######################################################################################
    #####     START SEND EMAILS
    ######################################################################################
    ######################################################################################

    ###################
    ### Send email to users with goals that have a checkpoint of 'email not yet sent'
    ###################
    for user in @users
    
      ###################
      #### DATE FUNCTIONS 
      ###################
      ### GET USER DATE and TIMENOW ###


      Time.zone = user.time_zone
      if Time.zone
        tnow = Time.zone.now + jump_forward_seconds #User time
      else
        tnow = Time.now + jump_forward_seconds
      end

      tlimit1 = tnow - (1 * 3600) # add 3600 seconds for each hour, so 14400 = 4 hours
      tlimit2 = tnow - (2 * 3600)
      tlimit3 = tnow - (3 * 3600)
      tlimit4 = tnow - (3 * 3600)
      tlimit5 = tnow - (3 * 3600)
      tlimit6 = tnow - (3 * 3600)
      tlimit7 = tnow - (3 * 3600)
      tlimit8 = tnow - (3 * 3600)
      #tlimit9 = tnow - (3 * 3600)

      tlimit1_k = tlimit1.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
      tlimit2_k = tlimit2.strftime("%k").to_i
      tlimit3_k = tlimit3.strftime("%k").to_i
      tlimit4_k = tlimit4.strftime("%k").to_i
      tlimit5_k = tlimit5.strftime("%k").to_i
      tlimit6_k = tlimit6.strftime("%k").to_i
      tlimit7_k = tlimit7.strftime("%k").to_i
      tlimit8_k = tlimit8.strftime("%k").to_i
      #tlimit9_k = tlimit9.strftime("%k").to_i

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
      d2daysago = dnow - 2
      dtomorrow = dnow + 1
      dtomorrow_plus1 = dtomorrow + 1

      ### previous day check-ins
      #checkin_date = dyesterday

      ### same-day check-ins
      checkin_date = dnow

      day_name = ""
      day_name_plus1 = ""
      yesterday_dayname = dyesterday.strftime("%A")
      today_dayname = dnow.strftime("%A")

      #puts "Yesterday was a #{yesterday_dayname}"
      if yesterday_dayname == "Monday"
          ###create the checkpoint and send the email       
          day_name = "daym"
          day_name_plus1 = "dayt"
      end
      if yesterday_dayname == "Tuesday"
          ###create the checkpoint and send the email       
          day_name = "dayt"
          day_name_plus1 = "dayw"
      end
      if yesterday_dayname == "Wednesday"
          ###create the checkpoint and send the email       
          day_name = "dayw"
          day_name_plus1 = "dayr"
      end
      if yesterday_dayname == "Thursday"
          ###create the checkpoint and send the email       
          day_name = "dayr"
          day_name_plus1 = "dayf"
      end
      if yesterday_dayname == "Friday"
          ###create the checkpoint and send the email       
          day_name = "dayf"
          day_name_plus1 = "days"
      end
      if yesterday_dayname == "Saturday"
          ###create the checkpoint and send the email       
          day_name = "days"
          day_name_plus1 = "dayn"
      end
      if yesterday_dayname == "Sunday"
          ###create the checkpoint and send the email       
          day_name = "dayn"
          day_name_plus1 = "daym"
      end
      #####
      ###################
      ###################
      #@goals = Goal.find(:all, :conditions => "status !='hold' and start < '#{dnow}' and stop >= '#{dnow}' and #{day_name} = '1'") 
      goal_conditions = "user_id = #{user.id}"
      goal_conditions = goal_conditions + " and status != 'hold'"
      #goal_conditions = goal_conditions + " and start < '#{dnow}' and stop >= '#{dnow}'"

      ### previous-day check-ins
      #goal_conditions = goal_conditions + " and ((start < '#{dnow}' and stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))"

      ### same-day check-ins
      goal_conditions = goal_conditions + " and ((start <= '#{dnow}' and stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))"


      #### previous day check-ins
      #goal_conditions = goal_conditions + " and #{day_name} = '1'" ### comment out this one line if not supporting days of the week

      #### same-day check-ins
      goal_conditions = goal_conditions + " and #{day_name_plus1} = '1'" ### comment out this one line if not supporting days of the week


      ### same-day check-ins
      goal_conditions = goal_conditions + " and ("

      ### just leave as "equal to" instead of ">=" ... if something happens where an hour or more is skipped,
      ### the separate "previous day" script will pick it up 
      goal_conditions = goal_conditions + "usersendhour = '#{tnow_k}'"      

      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit1_k}'"
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit2_k}'"
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit3_k}'"          
      goal_conditions = goal_conditions + ")"

      @goals = Goal.find(:all, :conditions => goal_conditions)
      for goal in @goals

        ### can't send more than XXXX emails per hour... leave a buffer for new goal creation emails of XXXX per hour
        if @stat.checkpointemailssent < maxemails
          ### Iterate through existing checkpoints for this goal
          @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal.id}' and checkin_date = '#{checkin_date}' and status = 'email not yet sent'")
          if @checkpoints.size > 0
            #puts "checkpoint awaiting an email for #{goal.id} on #{checkin_date}"
            ######################################################################################################################################
            ### Now see if that same user has additional goals
  ######################################################################################################################################
            @goals_additional = Goal.find(:all, :conditions => goal_conditions)
            
            ### 20110320 ... modified to allow for toggling of "send separate emails if i choose"
            #if @goals_additional.size == 1

            ### 20130123 ... since these are time-specific check-ins, just combine them always if they have same-time check-ins
            #if @goals_additional.size == 1 or user.combine_daily_emails == 0
            if @goals_additional.size == 1

              #### This user only has one matching goal,
              #### OR This user wants one email per goal,
              ####  so proceed normally with a single goal email
              logtext = "Emailing #{goal.user.email} single goal email for #{goal.id} for #{checkin_date}. Their time is #{tnow.to_s}. Server time is #{tservernow.to_s}."
              puts logtext
              logger.info logtext 
              begin
                limit_one = 0
                for checkpoint in @checkpoints
                  if limit_one == 0
                    limit_one = limit_one + 1
                    ### increment the number of emails going out
                    @stat.checkpointemailssent = @stat.checkpointemailssent + 1
                    @stat.save
                    checkpoint.status = 'email queued'
                    checkpoint.save
                    #if checkpoint.save
                    # #puts "Checkpoint was successfully updated to 'email queued'."
                    #end                
                    #puts "start notifier deliver"
                    if send_emails == 1
                      sent_successfully = true
                      if checkpoint.goal.user.sponsor == "clearworth"
                        begin
			    ### risky to put this before the actual send, but can't figure out why it fails every few weeks when it used to be "after" the actual send
			    checkpoint.status = 'email sent'
			    checkpoint.save

                            Notifier.deliver_checkpoint_notification_sameday_clearworth(checkpoint) # sends the email                                
                            sent_successfully = true
                        rescue
                            checkpoint.status = 'email failure'
                            checkpoint.save
                            the_message = "SGJerror failed to send single sameday CLEARWORTH checkpoint email to " + checkpoint.goal.user.email 
                            puts the_message
                            logger.error the_message
                        end
                      elsif checkpoint.goal.user.sponsor == "forittobe"
                        begin
                            ### risky to put this before the actual send, but can't figure out why it fails every few weeks when it used to be "after" the actual send
                            checkpoint.status = 'email sent'
                            checkpoint.save

                            Notifier.deliver_checkpoint_notification_sameday_forittobe(checkpoint) # sends the email                                
                            sent_successfully = true
                        rescue
                            checkpoint.status = 'email failure'
                            checkpoint.save
                            the_message = "SGJerror failed to send single sameday FORITTOBE checkpoint email to " + checkpoint.goal.user.email 
                            puts the_message
                            logger.error the_message
                        end
                      else
                        begin
                            ### risky to put this before the actual send, but can't figure out why it fails every few weeks when it used to be "after" the actual send
	                    logger.info("sgj:about to set checkpoint status to 'email sent' and then save")
                            checkpoint.status = 'email sent'
                            checkpoint.save
	                    logger.info("sgj:successfully set checkpoint status to 'email sent' and saved")


	                    logger.info("sgj:about to email checkppoint email to " + checkpoint.goal.user.email)
                            Notifier.deliver_checkpoint_notification_sameday(checkpoint) # sends the email                                
	                    logger.info("sgj:back from sending email checkppoint email to " + checkpoint.goal.user.email)

                            sent_successfully = true
                        rescue
                            checkpoint.status = 'email failure'
                            checkpoint.save
                            the_message = "SGJerror failed to send single sameday HF checkpoint email to " + checkpoint.goal.user.email 
                            puts the_message
                            logger.error the_message
                        end
                      end
                      #puts "sent email cause I was told to"
                    else
                      #puts "would have sent email, but was told not to"
                    end
                    #puts "end notifier deliver"
                    #### cause a failure
                    #@stat.BADBADBAD
                    

		    #### used to have this here, but occasionally the email would send successfully w/out getting here, thus causing emails to keep sending
		    #if sent_successfully
                    #    checkpoint.status = 'email sent'
                    #end
                    #if checkpoint.save
                    #  #puts "Checkpoint was successfully updated to 'email sent'."
                    #end                
                  end
                end
              rescue
                puts "Sorry, something went wrong"

                ### notify support@habitforge.com that the script died and the goal id
                Notifier.deliver_notify_support(goal) # sends the email  
                limit_one = 0
                for checkpoint in @checkpoints
                  if limit_one == 0
                    limit_one = limit_one + 1
                    checkpoint.status = 'email failure'
                    checkpoint.save
                  end
                end
              end      
            else
              #### This user has more goals that just this one, so concatonate them into one email
              #puts "This user has more goals that just this one (#{@goals_additional.size}), so concatonate them into one email"
              limit_one = 0
              for goal_additional in @goals_additional
                begin
                  email_sent_successfully = false
                  @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal_additional.id}' and checkin_date = '#{checkin_date}' and status = 'email not yet sent'")
                  if @checkpoints.size == 1
                    #puts "Updating #{goal_additional.user.email}'s goal #{goal_additional.id}, checkpoint of #{checkin_date}."
                    for checkpoint in @checkpoints
                      checkpoint.status = 'email queued'
                      checkpoint.save

                      #if checkpoint.save
                      # #puts "SUCCESS Checkpoint was successfully updated to 'email queued'."
                      #end                
                    end            
                  end              
                  if limit_one == 0
                    limit_one = limit_one + 1
                    ### increment the number of emails going out
                    @stat.checkpointemailssent = @stat.checkpointemailssent + 1
                    @stat.save
                    logtext = "Sending multi-checkpoint email to #{goal_additional.user.email} for checkpoint #{today_dayname}, #{checkin_date}. Their time is #{tnow.to_s}. Server time is #{tservernow.to_s}."          
                    puts logtext
                    logger.info logtext 

                    if send_emails == 1
                      for checkpoint in @checkpoints
                        if checkpoint.goal.user.sponsor == "clearworth"
                            ### risky to put this before the actual send, but can't figure out why it fails every few weeks when it used to be "after" the actual send
                            checkpoint.status = 'email sent'
                            checkpoint.save

                                if Notifier.deliver_checkpoint_notification_multiple_sameday_clearworth(checkpoint) # sends the email                                
                                    email_sent_successfully = true
                                else
                                    the_message = "SGJerror failed to send multiple sameday clearworth checkpoint email to " + checkpoint.goal.user.email 
                                    puts the_message
                                    logger.error the_message
                                end
                        elsif checkpoint.goal.user.sponsor == "forittobe"
                            ### risky to put this before the actual send, but can't figure out why it fails every few weeks when it used to be "after" the actual send
                            checkpoint.status = 'email sent'
                            checkpoint.save

                                if Notifier.deliver_checkpoint_notification_multiple_sameday_forittobe(checkpoint) # sends the email              
                                    email_sent_successfully = true
                                else
                                    the_message = "SGJerror failed to send multiple sameday FORITTOBE checkpoint email to " + checkpoint.goal.user.email 
                                    puts the_message
                                    logger.error the_message
                                end

                        else
                            ### risky to put this before the actual send, but can't figure out why it fails every few weeks when it used to be "after" the actual send
                            checkpoint.status = 'email sent'
                            checkpoint.save

                                if Notifier.deliver_checkpoint_notification_multiple_sameday(checkpoint) # sends the email              
                                    email_sent_successfully = true
                                else
                                    the_message = "SGJerror failed to send multiple sameday HF checkpoint email to " + checkpoint.goal.user.email 
                                    puts the_message
                                    logger.error the_message
                                end
                        end
                        #puts "sent email cause I was told to"
                      end
                    else
                      #puts "would have sent email, but was told not to"
                    end
                    #### cause a failure
                    #@stat.BADBADBAD
                  end

		  #### used to enable this below (after email sending instead of before), but had recurring issue of emails sending but status still not getting updated so multiple emails
                  #if @checkpoints.size == 1
                  #  #puts "Updating #{goal_additional.user.email}'s goal #{goal_additional.id}, checkpoint of #{checkin_date}."
                  #  for checkpoint in @checkpoints
                  #    if email_sent_successfully
                  #        checkpoint.status = 'email sent'
                  #    else
                  #        checkpoint.status = 'email failure'
                  #    end
                  #    if checkpoint.save
                  #      #puts "SUCCESS Checkpoint was successfully updated to 'email sent'."
                  #    end                
                  #  end            
                  #end              
                rescue
                  #puts "Sorry, something went wrong"
                  ### notify support@habitforge.com that the script died and the goal id
                  Notifier.deliver_notify_support(goal) # sends the email  
                  @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal_additional.id}' and checkin_date = '#{checkin_date}' and status = 'email not yet sent'")
                  for checkpoint in @checkpoints
                    checkpoint.status = 'email failure'
                    checkpoint.save
                  end
                end
              end
            end        
          end
        end
      end
    end
    ######################################################################################
    ######################################################################################
    #####     END SEND EMAILS
    ######################################################################################
    ######################################################################################
    ######################################################################################
    ######################################################################################
    




  puts "#{@stat.checkpointemailssent} emails sent this hour"

   #@stat.checkpointemailssent
   #@stat.totalheckpointemailfailure
   #@stat.goalcount
   #@stat.usercount
   #@stat.recorddate
   #@stat.recordhour  
   Notifier.deliver_notify_support_stats(@stat) # sends the email  

    
    puts "end of script"
    FileUtils.touch 'finished_update_stats_at'    
  rescue Timeout::Error
    puts "Timeout error on run number #{retried_times}... restarting script from the top"
    if retried_times < retried_times_limit
      retry
    end
  end
end
