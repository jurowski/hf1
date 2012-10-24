require 'active_record'
require 'date'
class UpdateGoalsGMTOffset < ActiveRecord::Base

  # This script:
  # 1. updates goal.gmtoffset based on user's time zone selection
  
  ### Whether to run the above steps
  run_1 = "yes"
  
  #FileUtils.touch 'tmp/launched_update_goals_gmtoffset_at'
  
  
  ### GET DATE NOW ###
  jump_forward_days = 0
  
  tnow = Time.now
  tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
  tnow_m = tnow.strftime("%m").to_i #month of the year
  tnow_d = tnow.strftime("%d").to_i #day of the month
  tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
  tnow_M = tnow.strftime("%M").to_i #minute of the hour
  #puts tnow_Y + tnow_m + tnow_d  
  puts "Current timestamp is #{tnow.to_s}"
  dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
  dyesterday = dnow - 1
  d2daysago = dnow - 2
  d7daysago = dnow - 7
  ######
  
  

  #######
  # START 1. updates goal.gmtoffset based on user's time zone selection
  # 
  #######
  if run_1 == "yes"
    @goals = Goal.find(:all, :order => "id desc")
    for goal in @goals
      puts "_______________"
      goal.usersendhour = 1
      Time.zone = goal.user.time_zone
      utcoffset = Time.zone.formatted_offset(false)
      offset_seconds = Time.zone.now.gmt_offset 
      send_time = Time.utc(2000, "jan", 1, goal.usersendhour, 0, 0) #2000-01-01 01:00:00 UTC
      central_time_offset = 21600 #add this in since we're doing UTC
      server_time = send_time - offset_seconds - central_time_offset
      puts "User lives in #{goal.user.time_zone} timezone, UTC offset of #{utcoffset} (#{offset_seconds} seconds)." #Save this value in each goal, and use that to do checkpoint searches w/ cronjob
      puts "For them to get an email at #{send_time.strftime('%k')} their time, the server would have to send it at #{server_time.strftime('%k')} Central time"
      goal.gmtoffset = utcoffset
      goal.serversendhour = server_time.strftime('%k')
      goal.save
    end
  end
  #######
  # END 1. updates goal.gmtoffset based on user's time zone selection
  # 
  #######

  

puts "end of script"
#FileUtils.touch 'tmp/finished_update_goals_gmtoffset_at'
end
