require 'active_record'
require 'date'
require 'logger'
class UpdatePromotionBlackFriday2014 < ActiveRecord::Base
  # This script emails people who had been paying InfusionSoft at $3.95/month and who can now use PayWhirl @ $1.29/month

  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/update_promotion_black_friday_2014.rb

  ### RUN IN PRODUCTION:
  ### cd /habitforge/current;RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/update_promotion_black_friday_2014.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/update_promotion_black_friday_2014.rb


  if `uname -n`.strip == 'adv.adventurino.com'
    #### HABITFORGE SETTINGS ON VPS
    testing = 0 #send emails to everyone as needed
    #testing = 1 #only send emails to "jurowski@gmail.com/jurowski@pediatrics.wisc.edu" as needed


    adjust_server_hour = 0 ### this server is listing its time as GMT -0600

    #send_emails = 0
    send_emails = 1
    
    test_user_id1 = "44"
    test_user_id2 = "13383"
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

  maxemails = 50
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
      user_conditions = "email = 'jurowski@gmail.com'"
    else
      user_conditions = "kill_ads_until is null and promotion_black_friday_2014_sent is null and (unsubscribed_from_promo_emails = 0 or unsubscribed_from_promo_emails is null)"    end
    @users = User.find(:all, :conditions => user_conditions, :limit => maxemails)

    for user in @users
        if count_emailed < maxemails
            run_once = 0
        		if user.promotion_black_friday_2014_sent == nil or testing == 1
        			if user.unsubscribed_from_promo_emails == nil or user.unsubscribed_from_promo_emails == 0 or testing == 1

                if !user.email.include? "xxx_"
       			      #puts "user.unsubscribed_from_promo_emails is nil or 0"
                  puts "#{user.email} is going to get an email"
                  
                  the_subject = "New Years Resolutions: Get 50% Off Premium + the New Lyphted (HabitForge) Newsletter"
                  Notifier.deliver_promotion_black_friday_2014(user, the_subject) # sends the email  

                  puts "#{user.email} was sent the promotion_black_friday_2014 NEWYEAR email"
                  
                  count_emailed = count_emailed + 1       
                end

                ### do this even if it is a xxx_ user
                user.promotion_black_friday_2014_sent = dnow
                user.save 

              end 
            end
        end
    end
    
    
    puts "end of script"
    FileUtils.touch 'finished_send_promo_emails_at'    
  rescue Timeout::Error
    puts "Timeout error on run number #{retried_times}... restarting script from the top"
    if retried_times < retried_times_limit
      retry
    end
  end
end
