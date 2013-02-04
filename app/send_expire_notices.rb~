require 'active_record'
require 'date'
require 'logger'
class SendExpireNotices < ActiveRecord::Base
  # This script emails people to notify them that their account will expire soon or has expired

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

  expire_warn = dnow + 30

  begin
    retried_times = retried_times + 1
    
    puts "start er up"


  ### MAKE SURE THEY DON'T GET THIS MORE THAN ONCE !!!! 

  user_conditions = ""
  user_conditions = user_conditions + "sponsor = 'habitforge'"
  #user_conditions = user_conditions + " and id = '29103'"
  user_conditions = user_conditions + " and kill_ads_until is not null"
  user_conditions = user_conditions + " and kill_ads_until < '#{expire_warn}'"

  ### AND don't send out the warnings if the date is in the past (if the expiration has already occured)
  user_conditions = user_conditions + " and kill_ads_until > '#{dnow}'"
  user_conditions = user_conditions + " and (sent_expire_warning_on is null or sent_expire_warning_on = '1900-01-01')"

    @users = User.find(:all, :conditions => user_conditions)
    for user in @users

        logtext = "About to send user_id of #{user.id.to_s} ( #{user.email} ) an expire warning."              
        puts logtext
        logger.info logtext 

        Notifier.deliver_user_expire_soon_notification(user) # sends the email 
        user.sent_expire_warning_on = user.dtoday
        user.save

        logtext = "Success emailing expire warning to #{user.email}."              
        puts logtext
        logger.info logtext 
    end
    
    puts "end of script"
  rescue Timeout::Error
    puts "Timeout error on run number #{retried_times}... restarting script from the top"
    if retried_times < retried_times_limit
      retry
    end
  end
end
