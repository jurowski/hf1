require 'active_record'
require 'date'
require 'logger'
class SendJobSearchRequest < ActiveRecord::Base
  # This script emails people asking people if they know of any good job opportunities


  ### RUN IN PRODUCTION:
  ### cd /habitforge/current;RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/send_job_search_request.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/send_job_search_request.rb

  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/send_job_search_request.rb


  tnow = Time.now
  tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
  tnow_m = tnow.strftime("%m").to_i #month of the year
  tnow_d = tnow.strftime("%d").to_i #day of the month
  tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
  tnow_k = tnow.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
  tnow_M = tnow.strftime("%M").to_i #minute of the hour
  #puts tnow_Y + tnow_m + tnow_d  
  #puts "Current timestamp is #{tnow.to_s}"
  dnow = Date.new(tnow_Y, tnow_m, tnow_d)

  retried_times = 0
  retried_times_limit = 50

  max = 25



  begin
    retried_times = retried_times + 1
    
    puts "start er up"


  ### MAKE SURE THEY DON'T GET THIS MORE THAN ONCE !!!! 

  user_conditions = ""
  user_conditions = user_conditions + "sponsor = 'habitforge'"
  #user_conditions = user_conditions + " and email = 'jurowski@gmail.com'"

  user_conditions = user_conditions + " and asked_for_job_lead_on is null"
  user_conditions = user_conditions + " and first_name != 'unknown'"
  user_conditions = user_conditions + " and update_number_active_goals > 0"


    @users = User.find(:all, :conditions => user_conditions, :limit => max)
    for user in @users

        logtext = "About to send user_id of #{user.id.to_s} ( #{user.email} ) a job lead email."              
        puts logtext
        logger.info logtext 


        begin
          Notifier.deliver_user_ask_for_job_lead(user) # sends the email 
          user.asked_for_job_lead_on = user.dtoday
          user.save

          logtext = "Success emailing job lead request to #{user.email}."              
          puts logtext
          logger.info logtext 

        rescue
          logtext = "Failure sending job lead email to #{user.email}."              
          puts logtext
          logger.info logtext 
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
