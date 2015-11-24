require 'active_record'
require 'date'
require 'logger'
class SeedEvents < ActiveRecord::Base
  # This script seeds eventsa


  if `uname -n`.strip == 'adv.adventurino.com'
    #### HABITFORGE SETTINGS ON VPS
    testing = 0 #send emails to everyone as needed
    #testing = 1 #only send emails to "jurowski@gmail.com/jurowski@pediatrics.wisc.edu" as needed


    adjust_server_hour = 0 ### this server is listing its time as GMT -0600

    #send_emails = 0
    send_emails = 1
    
    test_user_id1 = "44"
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
    test_user_id2 = "44"
  end


  jump_forward_days = 0
  
  ## add 3600 seconds for each hour, so 14400 = 4 hours.... won't affect the day/date... just the hour, for time zone re-sending if failures occurred, you could move the hour forward or backward
  hours_to_jump = 0
  jump_forward_seconds = (hours_to_jump + adjust_server_hour) * 3600  
  
  retried_times = 0
  retried_times_limit = 50

  attempt_to_resend_failures = 0
  #attempt_to_resend_failures = 1  

  maxemails = 10
  puts "Max emails to send per hour = #{maxemails}"

  count_emailed = 0
  begin
    
    puts "start er up"
    FileUtils.touch 'launched_send_promo_emails_at'

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

    tlimit1_k = tlimit1.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
    
    tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
    tnow_m = tnow.strftime("%m").to_i #month of the year
    tnow_d = tnow.strftime("%d").to_i #day of the month
    tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
    tnow_k = tnow.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
    tnow_M = tnow.strftime("%M").to_i #minute of the hour
    #puts tnow_Y + tnow_m + tnow_d  
    puts "Current timestamp is #{tnow.to_s}"
    dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
    dyesterday = dnow - 1
    d2daysago = dnow - 2
    dtomorrow = dnow + 1
    dtomorrow_plus1 = dtomorrow + 1
    months_ago_2 = dnow - 60

    tservernow = tnow
    ######
    ###################
    ###################

    user_conditions = ""
    if testing == 1 ### assuming adminuseremail of "jurowski@gmail.com" or "jurowski@pediatrics.wisc.edu"
      user_conditions = "id = '#{test_user_id1}' or id = '#{test_user_id2}'"
      months_ago_2 = dnow
    end
    @users = User.find(:all, :conditions => user_conditions, :order => "updated_at DESC")

    for user in @users
        email_this_user = 0
        if count_emailed < maxemails
            puts "counter = #{count_emailed}"
            puts "user.updated_at = #{user.updated_at}"
            puts "months_ago_2 = #{months_ago_2}"
            
            run_once = 0
            @goals = Goal.find(:all, :conditions => "user_id = #{user.id}", :order => "updated_at DESC") 
            for goal in @goals
                if run_once == 0
                    run_once = 1
                    ### If the newest goal hasn't been touched in 2 months, email them
                    if goal.updated_at < months_ago_2
                        email_this_user = 1
                        puts "yes, newest goal.updated_at < months_ago_2"
                    end
                end
            end
            if email_this_user == 1 or testing == 1
        		if user.promo_1_sent == nil or user.promo_1_sent == 0 or testing == 1
        		    puts "promo_1_sent is nil or 0" 
        			if user.unsubscribed_from_promo_emails == nil or user.unsubscribed_from_promo_emails == 0 or testing == 1
        			      puts "user.unsubscribed_from_promo_emails is nil or 0"
        			      # rand token string from: http://blog.logeek.fr/2009/7/2/creating-small-unique-tokens-in-ruby
                          user.promo_1_token = rand(36**8).to_s(36)
                          
                          puts "token = #{user.promo_1_token}"
                          puts "#{user.email} is going to get an email"
                          
                          the_subject = "Start Your 2011 New Years Resolution Now!!!"
                          Notifier.deliver_promotion_1(user, the_subject) # sends the email  

                          puts "#{user.email} was sent the promo_1 the email"

                          user.promo_1_sent = 1
                          user.save 
                          
                          count_emailed = count_emailed + 1       
                    end 
                end
            end
        end
    end
    
   #puts "#{@stat.checkpointemailssent} emails sent this hour"
   #Notifier.deliver_notify_support_send_promo_emails(@stat) # sends the email  

    
    puts "end of script"
    FileUtils.touch 'finished_send_promo_emails_at'    
  rescue Timeout::Error
    puts "Timeout error on run number #{retried_times}... restarting script from the top"
    if retried_times < retried_times_limit
      retry
    end
  end
end
