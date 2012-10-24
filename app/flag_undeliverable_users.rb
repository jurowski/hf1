require 'active_record'
require 'date'
require 'logger'
#require 'file'

class FlagUndeliverableUsers < ActiveRecord::Base

  # This script marks as undeliverable those user accounts that email could not be delivered to
  # to help with knowing who can more safely be imported into a mailing list service


    ###################
    #### DATE FUNCTIONS 
    ###################
    ### GET SERVER DATE AND TIME NOW ###

    #### THIS IS SERVER DATE/TIME FOR USE W/STATS... DON'T WANT USER TIME
    #Time.zone = current_user.time_zone
    #tnow = Time.zone.now #User time

    jump_forward_days = 0
    jump_forward_seconds = 0
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
    months_ago_6 = dnow - 180

    tservernow = tnow

    ### 15552000 = 6 months of seconds
    months_ago_6_in_seconds = tnow - 15552000

    ######
    ###################
    ###################

  total_bad = 0

  testing = false
  max_to_test = 100

  user_conditions = "promo_comeback_last_sent is not null and undeliverable_date_checked is null"
  #user_conditions = "email = 'dristz@yahoo.com'"

  users = User.find(:all, :limit => max_to_test, :conditions => user_conditions)

  for user in users
    hit = false 
    if File.readlines("/var/log/exim_mainlog").grep(/\*\* #{user.email}/).any?
      hit = true
    end

    if File.readlines("/var/log/exim_mainlog.1").grep(/\*\* #{user.email}/).any?
      hit = true
    end


    user.undeliverable_date_checked = dnow
    if hit
      puts "found a bad one: " + user.email
      total_bad += 1
      user.undeliverable = true
    else
      puts user.email + " is OK"
    end
    user.save
  end
 
  if testing
      puts "testing only, but would have flagged a total of = #{total_bad.to_s}"
  else
      puts "total_bad = #{total_bad.to_s}"
  end

  
  puts "end of script"

  

end
