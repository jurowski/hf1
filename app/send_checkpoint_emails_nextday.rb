require 'active_record'
require 'date'
require 'logger'
class SendCheckpointEmails < ActiveRecord::Base
  # This NEXTDAY script emails people who have checkins due on their goals from the previous day



  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/send_checkpoint_emails_nextday.rb

  ### RUN IN PRODUCTION:
  ### cd /habitforge/current;RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/send_checkpoint_emails_nextday.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/send_checkpoint_emails_nextday.rb


  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/send_checkpoint_emails.rb

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
  cronjob.name = "send_checkpoint_emails.rb"
  cronjob.started_at = DateTime.now
  cronjob.notes = ""
  cronjob.save


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

    test_user_id1 = "83426"
    test_user_id2 = "44"
  end





  jump_forward_days = 0
  
  ## add 3600 seconds for each hour, so 14400 = 4 hours.... won't affect the day/date... just the hour, for time zone re-sending if failures occurred, you could move the hour forward or backward
  hours_to_jump = 0
  ## hours_to_jump = -5

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
    #FileUtils.touch 'launched_update_stats_at'


    
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
    #tlimit10 = tnow - (10 * 3600)
    #tlimit11 = tnow - (11 * 3600)
    #tlimit12 = tnow - (12 * 3600)
    #tlimit13 = tnow - (13 * 3600)
    #tlimit14 = tnow - (14 * 3600)
    #tlimit15 = tnow - (15 * 3600)
    #tlimit16 = tnow - (16 * 3600)
    #tlimit17 = tnow - (17 * 3600)
    #tlimit18 = tnow - (18 * 3600)
    #tlimit19 = tnow - (19 * 3600)
    #tlimit20 = tnow - (20 * 3600)



    tlimit1_k = tlimit1.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
    tlimit2_k = tlimit2.strftime("%k").to_i
    tlimit3_k = tlimit3.strftime("%k").to_i
    tlimit4_k = tlimit4.strftime("%k").to_i
    tlimit5_k = tlimit5.strftime("%k").to_i
    tlimit6_k = tlimit6.strftime("%k").to_i
    tlimit7_k = tlimit7.strftime("%k").to_i
    tlimit8_k = tlimit8.strftime("%k").to_i
    #tlimit9_k = tlimit9.strftime("%k").to_i
    #tlimit10_k = tlimit10.strftime("%k").to_i
    #tlimit11_k = tlimit11.strftime("%k").to_i
    #tlimit12_k = tlimit12.strftime("%k").to_i
    #tlimit13_k = tlimit13.strftime("%k").to_i
    #tlimit14_k = tlimit14.strftime("%k").to_i
    #tlimit15_k = tlimit15.strftime("%k").to_i
    #tlimit16_k = tlimit16.strftime("%k").to_i
    #tlimit17_k = tlimit17.strftime("%k").to_i
    #tlimit18_k = tlimit18.strftime("%k").to_i
    #tlimit19_k = tlimit19.strftime("%k").to_i
    #tlimit20_k = tlimit20.strftime("%k").to_i


    
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


    user_conditions = ""
    if testing == 1 ### assuming adminuseremail of "jurowski@gmail.com" or "jurowski@pediatrics.wisc.edu"
      user_conditions = "id = '#{test_user_id1}' or id = '#{test_user_id2}'"
    else
      user_conditions = "update_number_active_goals > 0 and confirmed_address = '1'"
    end


    if @users
      puts "going through " + @users.size.to_s + " users"
    else
      puts "zero users"
    end


    first_name_letter_array = [['a','b','c','d'],['e','f','g','h','i'],['j','k','l','m','n','o','p'],['q','r','s','t','u','v'],['w','x','y','z']]
    first_name_letter_array.each do |first_name_letter|


      logtext = "Creating checkpoints for #{first_name_letter[0]} through #{first_name_letter[1]}"
      puts logtext
      logger.info logtext 




    @users = User.find(:all, :conditions => user_conditions)
    for user in @users
      ###################
      #### DATE FUNCTIONS 
      ###################
      ### GET USER DATE and TIMENOW ###

      found_match = false
      first_name_downcase = user.first_name.downcase[0]
      first_name_letter.each do |letter_check|
        if first_name_downcase == letter_check[0]
          # puts "!" + user.first_name + " "
          found_match = true
        # else
          # puts first_name_downcase.to_s + "<>" + letter_check[0].to_s
        end
      end
      if found_match


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
      #tlimit10 = tnow - (10 * 3600)
      #tlimit11 = tnow - (11 * 3600)
      #tlimit12 = tnow - (12 * 3600)
      #tlimit13 = tnow - (13 * 3600)
      #tlimit14 = tnow - (14 * 3600)
      #tlimit15 = tnow - (15 * 3600)
      #tlimit16 = tnow - (16 * 3600)
      #tlimit17 = tnow - (17 * 3600)
      #tlimit18 = tnow - (18 * 3600)
      #tlimit19 = tnow - (19 * 3600)
      #tlimit20 = tnow - (20 * 3600)

      tlimit1_k = tlimit1.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
      tlimit2_k = tlimit2.strftime("%k").to_i
      tlimit3_k = tlimit3.strftime("%k").to_i
      tlimit4_k = tlimit4.strftime("%k").to_i
      tlimit5_k = tlimit5.strftime("%k").to_i
      tlimit6_k = tlimit6.strftime("%k").to_i
      tlimit7_k = tlimit7.strftime("%k").to_i
      tlimit8_k = tlimit8.strftime("%k").to_i
      #tlimit9_k = tlimit9.strftime("%k").to_i
      #tlimit10_k = tlimit10.strftime("%k").to_i
      #tlimit11_k = tlimit11.strftime("%k").to_i
      #tlimit12_k = tlimit12.strftime("%k").to_i
      #tlimit13_k = tlimit13.strftime("%k").to_i
      #tlimit14_k = tlimit14.strftime("%k").to_i
      #tlimit15_k = tlimit15.strftime("%k").to_i
      #tlimit16_k = tlimit16.strftime("%k").to_i
      #tlimit17_k = tlimit17.strftime("%k").to_i
      #tlimit18_k = tlimit18.strftime("%k").to_i
      #tlimit19_k = tlimit19.strftime("%k").to_i
      #tlimit20_k = tlimit20.strftime("%k").to_i
      
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
      goal_conditions = goal_conditions + " and check_in_same_day = '0'"
      goal_conditions = goal_conditions + " and ((start < '#{dnow}' and stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))"
      goal_conditions = goal_conditions + " and #{day_name} = '1'"   #comment out this one line if not supporting days of the week
      goal_conditions = goal_conditions + " and ("
      goal_conditions = goal_conditions + "usersendhour = '#{tnow_k}'"      
      goal_conditions = goal_conditions + " or usersendhour = '#{tlimit1_k}'"
      goal_conditions = goal_conditions + " or usersendhour = '#{tlimit2_k}'"
      goal_conditions = goal_conditions + " or usersendhour = '#{tlimit3_k}'"      
      goal_conditions = goal_conditions + " or usersendhour = '#{tlimit4_k}'"      
      goal_conditions = goal_conditions + " or usersendhour = '#{tlimit5_k}'"      
      goal_conditions = goal_conditions + " or usersendhour = '#{tlimit6_k}'"      
      goal_conditions = goal_conditions + " or usersendhour = '#{tlimit7_k}'"      
      goal_conditions = goal_conditions + " or usersendhour = '#{tlimit8_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit9_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit10_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit11_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit12_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit13_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit14_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit15_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit16_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit17_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit18_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit19_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit20_k}'"      
      goal_conditions = goal_conditions + ")"
      
      @goals = Goal.find(:all, :conditions => goal_conditions)
      for goal in @goals
        ###################
        ###################
        ### CREATE ALL CHECKPOINTS FIRST FOR THIS USER's Matching Goals
        ### (so that people can manually update their status if emails aren't going out)
        ###################
        ###################
        if create_checkpoints == 1
          checkin_date = dyesterday
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
              logtext = "#{checkpoint.goal.user.email} gets a checkpoint for #{yesterday_dayname}, #{checkin_date}. Their time is #{tnow.to_s}. Server time is #{tservernow.to_s}."              
              puts logtext
              logger.info logtext 
            else
              the_message = "ERROR creating checkpoint for #{goal.id} on #{checkin_date}"
              puts the_message         
              cronjob.notes += "<br>" + the_message
            end
            #### END CREATE CHECKPOINT
          end    
        end
        ###################
        ### DONE CREATING ALL CHECKPOINTS FOR THIS USER
        ###################
      end
    end ### if user is in the range of letters
    end ### for user in users
    end ### for each grouping of letters
    


    ##### _______________________________________________________________________________________________________________________________________________________________________________
    #####               |                         ------------------          C L I E N T   T I M E            ------------------                                                       |
    ##### Server Time   _________________________________________________________________________________________________________________________________________________________________
    #####   (-0600)     |               01 (1am)              |               02 (2am)               |                03 (3am)               |            04 (4am)                      |
    ##### 			      	_________________________________________________________________________________________________________________________________________________________________
    #####				        |											                      	Format: [ServerSendHour (client GMT;client day)]																	                                |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 00 (12am)  | 00 (-0500;today)                    |  23 (-0400, -0430 and -0330;today)   |  22 (-0300;today)                     |  21 (-0200;today)                        |
    ##### _______________________________________________________________________________________________________________________________________________________________________________    
    ##### at 01 (01am)  | 01 (-0600;today)                    |  00 (-0500;today)                    |  23 (-0400, -0430 and -0330;today)    |  22 (-0300;today)                        |
    ##### _______________________________________________________________________________________________________________________________________________________________________________    
    ##### at 02 (02am)  | 02 (-0700;today)                    |  01 (-0600;today)                    |  00 (-0500;today)                     |  23 (-0400, -0430 and -0330;today)       |
    ##### _______________________________________________________________________________________________________________________________________________________________________________    
    ##### at 03 (03am)  | 03 (-0800;today)                    |  02 (-0700;today)                    |  01 (-0600;today)                     |  00 (-0500;today)                        | 
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 04 (04am)  | 04 (-0900;today)                    |  03 (-0800;today)                    |  02 (-0700;today)                     |  01 (-0600;today)                        |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 05 (05am)  | 05 (+1400;tomorrow and -1000;today) |  04 (-0900;today)                    |  03 (-0800;today)                     |  02 (-0700;today)                        |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 06 (06am)  | 06 (+1300;tomorrow and -1100;today) |  05 (+1400;tomorrow and -1000;today) |  04 (-0900;today)                     |  03 (-0800;today)                        |
    ##### _______________________________________________________________________________________________________________________________________________________________________________    
    ##### at 07 (07am)  | 07 (+1200;tomorrow and -1200;today) |  06 (+1300;tomorrow and -1100;today) |  05 (+1400;tomorrow and -1000;today)  |  04 (-0900;today)                        |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 08 (08am)  | 08 (+1100;tomorrow)                 |  07 (+1200;tomorrow and -1200;today) |  06 (+1300;tomorrow and -1100;today)  |  05 (+1400;tomorrow and -1000;today)     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 09 (09am)  | 09 (+1000, +0930;tomorrow)          |  08 (+1100;tomorrow)                 |  07 (+1200;tomorrow and -1200;today)  |  06 (+1300;tomorrow and -1100;today)     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 10 (10am)  | 10 (+0900;tomorrow)                 | 09 (+1000, +0930;tomorrow)           |  08 (+1100;tomorrow)                  |  07 (+1200;tomorrow and -1200;today)     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 11 (11am)  | 11 (+0800;tomorrow)                 |  10 (+0900;tomorrow)                 | 09 (+1000, +0930;tomorrow)            |  08 (+1100;tomorrow)                     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 12 (12pm)  | 12 (+0700;tomorrow)                 |  11 (+0800;tomorrow)                 |  10 (+0900;tomorrow)                  | 09 (+1000, +0930;tomorrow)               |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 13 (1pm)   | 13 (+0600, +0545, +0530;tomorrow)   |  12 (+0700;tomorrow)                 |  11 (+0800;tomorrow)                  |  10 (+0900;tomorrow)                     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 14 (2pm)   | 14 (+0500 and +0430;tomorrow)       | 13 (+0600, +0545, +0530;tomorrow)    |  12 (+0700;tomorrow)                  |  11 (+0800;tomorrow)                     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 15 (3pm)   | 15 (+0400 and +0330;tomorrow)       | 14 (+0500 and +0430;tomorrow)        | 13 (+0600, +0545, +0530;tomorrow)     |  12 (+0700;tomorrow)                     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 16 (4pm)   | 16 (+0300;tomorrow)                 | 15 (+0400 and +0330;tomorrow)        | 14 (+0500 and +0430;tomorrow)         | 13 (+0600, +0545, +0530;tomorrow)        |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 17 (5pm)   | 17 (+0200;tomorrow)                 |  16 (+0300;tomorrow)                 | 15 (+0400 and +0330;tomorrow)         | 14 (+0500 and +0430;tomorrow)            |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 18 (6pm)   | 18 (+0100;tomorrow)                 |  17 (+0200;tomorrow)                 |  16 (+0300;tomorrow)                  | 15 (+0400 and +0330;tomorrow)            |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 19 (7pm)   | 19 (+0000;tomorrow)                 |  18 (+0100;tomorrow)                 |  17 (+0200;tomorrow)                  |  16 (+0300;tomorrow)                     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 20 (8pm)   | 20 (-0100;tomorrow)                 |  19 (+0000;tomorrow)                 |  18 (+0100;tomorrow)                  |  17 (+0200;tomorrow)                     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 21 (9pm)   | 21 (-0200;tomorrow)                 |  20 (-0100;tomorrow)                 |  19 (+0000;tomorrow)                  |  18 (+0100;tomorrow)                     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 22 (10pm)  | 22 (-0300;tomorrow)                 |  21 (-0200;tomorrow)                 |  20 (-0100;tomorrow)                  |  19 (+0000;tomorrow)                     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________
    ##### at 23 (11pm)  | 23 (-0400,-0430 and -0330;tomorrow) |  22 (-0300;tomorrow)                 |  21 (-0200;tomorrow)                  |  20 (-0100;tomorrow)                     |
    ##### _______________________________________________________________________________________________________________________________________________________________________________


    if @users
      puts "going through " + @users.size.to_s + " users"
    else
      puts "zero users"
    end


    first_name_letter_array = [['a','b','c','d'],['e','f','g','h','i'],['j','k','l','m','n','o','p'],['q','r','s','t','u','v'],['w','x','y','z']]
    first_name_letter_array.each do |first_name_letter|


      logtext = "Processing emails for #{first_name_letter[0]} through #{first_name_letter[1]}"
      puts logtext
      logger.info logtext 


    ###################
    ### Send email to users with goals that have a checkpoint of 'email not yet sent'
    ###################
    for user in @users



      found_match = false
      first_name_downcase = user.first_name.downcase[0]
      first_name_letter.each do |letter_check|
        if first_name_downcase == letter_check[0]
          # puts "!" + user.first_name + " "
          found_match = true
        # else
          # puts first_name_downcase.to_s + "<>" + letter_check[0].to_s
        end
      end
      if found_match

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
      #tlimit10 = tnow - (3 * 3600)
      #tlimit11 = tnow - (3 * 3600)
      #tlimit12 = tnow - (3 * 3600)
      #tlimit13 = tnow - (3 * 3600)
      #tlimit14 = tnow - (3 * 3600)
      #tlimit15 = tnow - (3 * 3600)
      #tlimit16 = tnow - (3 * 3600)
      #tlimit17 = tnow - (3 * 3600)
      #tlimit18 = tnow - (3 * 3600)
      #tlimit19 = tnow - (3 * 3600)
      #tlimit20 = tnow - (3 * 3600)



      tlimit1_k = tlimit1.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
      tlimit2_k = tlimit2.strftime("%k").to_i
      tlimit3_k = tlimit3.strftime("%k").to_i
      tlimit4_k = tlimit4.strftime("%k").to_i
      tlimit5_k = tlimit5.strftime("%k").to_i
      tlimit6_k = tlimit6.strftime("%k").to_i
      tlimit7_k = tlimit7.strftime("%k").to_i
      tlimit8_k = tlimit8.strftime("%k").to_i
      #tlimit9_k = tlimit9.strftime("%k").to_i
      #tlimit10_k = tlimit10.strftime("%k").to_i
      #tlimit11_k = tlimit11.strftime("%k").to_i
      #tlimit12_k = tlimit12.strftime("%k").to_i
      #tlimit13_k = tlimit13.strftime("%k").to_i
      #tlimit14_k = tlimit14.strftime("%k").to_i
      #tlimit15_k = tlimit15.strftime("%k").to_i
      #tlimit16_k = tlimit16.strftime("%k").to_i
      #tlimit17_k = tlimit17.strftime("%k").to_i
      #tlimit18_k = tlimit18.strftime("%k").to_i
      #tlimit19_k = tlimit19.strftime("%k").to_i
      #tlimit20_k = tlimit20.strftime("%k").to_i

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

      checkin_date = dyesterday

      day_name = ""
      day_name_plus1 = ""
      yesterday_dayname = dyesterday.strftime("%A")
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
      goal_conditions = goal_conditions + " and ((start < '#{dnow}' and stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))"
      goal_conditions = goal_conditions + " and #{day_name} = '1'" ### comment out this one line if not supporting days of the week
      #goal_conditions = goal_conditions + " and ("
      #goal_conditions = goal_conditions + "usersendhour = '#{tnow_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit1_k}'"
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit2_k}'"
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit3_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit4_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit5_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit6_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit7_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit8_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit9_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit10_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit11_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit12_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit13_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit14_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit15_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit16_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit17_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit18_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit19_k}'"      
      #goal_conditions = goal_conditions + " or usersendhour = '#{tlimit20_k}'"      
      #goal_conditions = goal_conditions + ")"

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
            if @goals_additional.size == 1 or user.combine_daily_emails == 0
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
                    checkpoint.status = 'email queued (nextday:665)'
                    if checkpoint.save
                      #puts "Checkpoint was successfully updated to 'email queued'."
                    end                
                    #puts "start notifier deliver"
                    if send_emails == 1
                      sent_successfully = true
                        begin
                            ### risky to put this before the actual send, but can't figure out why it fails every few weeks when it used to be "after" the actual send
                            checkpoint.status = 'email sent'
                            checkpoint.save

                            # Notifier.deliver_checkpoint_notification(checkpoint) # sends the email                                
                            # sent_successfully = true


                            event_queue = EventQueue.new()
                            event_type_string = "email checkpoint nextday"
                            event_type = EventType.find(:first, :conditions => "name = '#{event_type_string}'")
                            if event_type
                              event_queue.event_type_id = event_type.id 
                            else
                              puts "ERROR event type not found for " + event_type_string + " so not added to event_queue"
                            end

                            event_queue.user_id = checkpoint.goal.user.id
                            event_queue.goal_id = checkpoint.goal.id
                            event_queue.checkpoint_id = checkpoint.id
                            event_queue.valid_at_datetime = tservernow
                            event_queue.expire_at_datetime = tservertomorrow
                            event_queue.status = "pending"

                            if event_queue.save
                              logtext = "#{checkpoint.goal.user.email} is added to event_queue with checkpoint #{checkpoint.id} for #{today_dayname}, #{checkin_date}."              
                              puts logtext
                              logger.info logtext 

                            else
                              puts "ERROR creating event_queue for #{checkpoint.id} on #{goal.id} on #{checkin_date}"        
                            end

                        rescue
                            checkpoint.status = 'email failure'
                            the_message = "SGJerror failed to queue single HF checkpoint email to " + checkpoint.goal.user.email 
                            puts the_message
                            logger.error the_message

                            cronjob.notes += "<br>" + the_message


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
              message = "This user has more goals that just this one (#{@goals_additional.size.to_s}), so concatonate them into one email"
              puts message
              logger.info("sgj:" + message)

              limit_one = 0
              for goal_additional in @goals_additional
                begin
                  email_sent_successfully = false
                  @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal_additional.id}' and checkin_date = '#{checkin_date}' and status = 'email not yet sent'")
                  if @checkpoints.size == 1
                    #puts "Updating #{goal_additional.user.email}'s goal #{goal_additional.id}, checkpoint of #{checkin_date}."
                    for checkpoint in @checkpoints
                      checkpoint.status = 'email queued (nextday:765)'
                      if checkpoint.save
                        #puts "SUCCESS Checkpoint was successfully updated to 'email queued'."
                      end                
                    end            
                  end              
                  if limit_one == 0
                    limit_one = limit_one + 1
                    ### increment the number of emails going out
                    @stat.checkpointemailssent = @stat.checkpointemailssent + 1
                    @stat.save
                    logtext = "Sending multi-checkpoint email to #{goal_additional.user.email} for checkpoint #{yesterday_dayname}, #{checkin_date}. Their time is #{tnow.to_s}. Server time is #{tservernow.to_s}."          
                    puts logtext
                    logger.info logtext 

                    if send_emails == 1
                      for checkpoint in @checkpoints
                            ### risky to put this before the actual send, but can't figure out why it fails every few weeks when it used to be "after" the actual send
                            checkpoint.status = 'email sent'
                            checkpoint.save

                            # if Notifier.deliver_checkpoint_notification_multiple(checkpoint) # sends the email              
                            #     email_sent_successfully = true
                            # else
                            #     the_message = "SGJerror failed to send multiple HF checkpoint email to " + checkpoint.goal.user.email 
                            #     puts the_message
                            #     logger.error the_message
                            #     cronjob.notes += "<br>" + the_message
                            # end

                            event_queue = EventQueue.new()
                            event_type_string = "email checkpoint multiple nextday"
                            event_type = EventType.find(:first, :conditions => "name = '#{event_type_string}'")
                            if event_type
                              event_queue.event_type_id = event_type.id 
                            else
                              puts "ERROR event type not found for " + event_type_string + " so not added to event_queue"
                            end

                            event_queue.user_id = checkpoint.goal.user.id
                            event_queue.goal_id = checkpoint.goal.id
                            event_queue.checkpoint_id = checkpoint.id
                            event_queue.valid_at_datetime = tservernow
                            event_queue.expire_at_datetime = tservertomorrow
                            event_queue.status = "pending"

                            if event_queue.save
                              logtext = "#{checkpoint.goal.user.email} is added to event_queue with checkpoint #{checkpoint.id} for #{today_dayname}, #{checkin_date}."              
                              puts logtext
                              logger.info logtext 

                            else
                              puts "ERROR creating event_queue for #{checkpoint.id} on #{goal.id} on #{checkin_date}"        
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
    end # for user in @users
    end # first_name_letter_array.each do |first_name_letter|
    end #  if (first_name_downcase >= first_name_letter[0].to_i) and (first_name_downcase <= first_name_letter[1].to_i)




   # #### If there's room to send more, try resending failures
   # if attempt_to_resend_failures == 1
   #   puts "looking for failures to resend"
   #   for goal in @goals
   #
   #
   #     checkin_date = dyesterday
   #     if goal.gmtoffset == nil
   #       goal.gmtoffset = '-0500'
   #       goal.save
   #     end
   #     if goal.gmtoffset >= '-0500' and goal.gmtoffset <= '-1200'
   #       ### same day... don't add anything to the date
   #     else
   #       ###############################################################
   #       ####### Remove most of this after it runs for the first couple of days
   #       ####### This is just here for the transition
   #       ####### ...after the first couple of days all you should need is: dyesterday = dyesterday + 1
   #
   #       ### make sure they got yesterday's checkpointlast checkpoint 
   #       @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal.id}' and checkin_date = '#{dyesterday}'")
   #       if @checkpoints.size == 0
   #         #### They didn't get their checkpoint from yesterday, so prior to incrementing the day, let's make sure they get this one first
   #         #### and we're running this w/ a 4 hour window, so we'll pick up the "next day" for them the next time around
   #       else
   #         ### when it's 1am in their timezone, they're a day ahead of us, so add a day to the checkpoint
   #         checkin_date = dyesterday + 1
   #       end
   #     end
   #
   #
   #     ### can't send more than 500 emails per hour... leave a buffer for new goal creation emails of 100 per hour
   #     if @stat.checkpointemailssent < maxemails
   #       ### Iterate through existing checkpoints for this goal
   #       @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal.id}' and checkin_date = '#{checkin_date}' and status = 'email failure'")
   #       checkpoint = Checkpoint.new
   #
   #       if @checkpoints.size > 0
   #         puts "checkpoint failure found for #{goal.title} on #{checkin_date}...going to try re-sending an email and updating checkpoint"
   #         puts "Emailing #{goal.user.email} re: goal #{goal.title} checkpoint of #{checkin_date}."
   #         begin
   #           for check in @checkpoints
   #             checkpoint = check
   #             checkpoint.status = 'email sent'            
   #             if checkpoint.save
   #               puts "Checkpoint was successfully updated to 'email sent'."
   #             end
   #             ### increment the number of emails going out
   #             @stat.checkpointemailssent = @stat.checkpointemailssent + 1
   #             @stat.save
   #
   #             puts "#{@stat.checkpointemailssent} emails sent this hour"
   #
   #             #### cause a failure
   #             #@stat.BADBADBAD
   #
   #             if send_emails == 1
   #               Notifier.deliver_checkpoint_notification(checkpoint) # sends the email               
   #               puts "sent email cause I was told to"
   #             else
   #               puts "would have sent email, but was told not to"
   #             end
   #
   #
   #           end
   #
   #         rescue
   #           puts "Sorry, something went wrong while resending a failure"
   #
   #           ### notify support@habitforge.com that the script died and the goal id
   #           Notifier.deliver_notify_support(goal) # sends the email  
   #           checkpoint.status = 'email failure'
   #           checkpoint.save
   #
   #         end      
   #       end
   #     end
   #   end  
   # end
   
  puts "#{@stat.checkpointemailssent} emails sent this hour"

   #@stat.checkpointemailssent
   #@stat.totalheckpointemailfailure
   #@stat.goalcount
   #@stat.usercount
   #@stat.recorddate
   #@stat.recordhour  
   Notifier.deliver_notify_support_stats(@stat) # sends the email  

    
    puts "end of script"
    #FileUtils.touch 'finished_update_stats_at'    
  rescue Timeout::Error
    the_message = "Timeout error on run number #{retried_times}... restarting script from the top"
    puts the_message
    cronjob.notes += "<br>" + the_message
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

  cronjob.metric_1_name = "emails sent this hour"
  cronjob.metric_1_value = @stat.checkpointemailssent
  cronjob.completed_at = DateTime.now
  cronjob.save

end
