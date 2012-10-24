require 'active_record'
require 'date'
require 'logger'
class UpdateAskForTestimonial < ActiveRecord::Base
  # This script emails people who have been doing well with their goals to ask for a testimonial


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

  maxemails = 700
  puts "Max emails to send per hour = #{maxemails}"

  count_emailed = 0
  begin
    
    puts "start er up"
    FileUtils.touch 'launched_ask_for_testimonial_at'

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
    d3daysago = dnow - 3
    dtomorrow = dnow + 1
    dtomorrow_plus1 = dtomorrow + 1
    months_ago_2 = dnow - 60
    months_ago_6 = dnow - 180

    tservernow = tnow

    ### 15552000 = 6 months of seconds
    months_ago_6_in_seconds = tnow - 15552000

    ######
    ###################
    ###################

    user_conditions = "sponsor = 'habitforge' and (unsubscribed_from_promo_emails is null or unsubscribed_from_promo_emails = '0') and (asked_for_testimonial is null or asked_for_testimonial = '0') and update_number_active_goals > '0'"
    if testing == 1 ### assuming adminuseremail of "jurowski@gmail.com" or "jurowski@pediatrics.wisc.edu"
      user_conditions = "email = 'jurowski@gmail.com'"
    end
    puts "looking for user_conditions: " + user_conditions
    @users = User.find(:all, :limit => maxemails, :conditions => user_conditions)

    if @users
      puts "found " + @users.size.to_s + " (limiting to " + maxemails.to_s + ")"
    end

    count_found = 0
    for user in @users
	goal_conditions = "user_id = '#{user.id}' and laststatusdate >= '#{dyesterday}' and laststatus = 'yes' and  days_into_it > '20' and success_rate_percentage > '74'"
        if testing == 1
	  goal_conditions = "days_into_it > '1'"
	end

        goal = Goal.find(:first, :conditions => goal_conditions)
	if goal
	  count_found = count_found + 1
          if count_emailed < maxemails
            #puts "counter = #{count_emailed}"
            #puts "user.updated_at = #{user.updated_at}"
            #puts "months_ago_2 = #{months_ago_6_in_seconds}"

                        if send_emails == 1 
                          the_subject = "You've been rocking it with HabitForge... would you mind telling us how it helps?"
                          Notifier.deliver_user_ask_for_testimonial(user, the_subject) # sends the email  

                          puts "#{user.email} was sent the ask_for_testimonial email"
			  
			  
                          user.asked_for_testimonial = 1
                          user.save

                          count_emailed = count_emailed + 1
			else
			  puts "would have emailed #{user.email} for a testimonial"
			end
          end
        end
    end
    
    
    puts "end of script"
    puts "found #{count_found}"
    FileUtils.touch 'finished_ask_for_testimonial_at'    
  rescue Timeout::Error
    puts "Timeout error on run number #{retried_times}... restarting script from the top"
    if retried_times < retried_times_limit
      retry
    end
  end
end
