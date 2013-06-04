require 'active_record'
class DeleteOldAccountData < ActiveRecord::Base


### RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/update_user-number_active_goals.rb
#RAILS_ENV=production 
#/usr/bin/ruby 
#/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
#/home/jurowsk1/etc/rails_apps/habitforge/current/app/update_user-number_active_goals.rb

  # This script:
  # deletes any user data for users who have not had activity in 1 year
  # and who are not paid users

  ### Whether to run the above steps
  run_1 = "yes"

  
  
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
  dlastyear = dnow - 365
  dlastweek = dnow - 7
  ######
    


  #######
  # START 1. delete any data for users who have not had activity for 1 year
  # 
  #######
  if run_1 == "yes"

    users = User.find(:all, :conditions => "kill_ads_until is null and updated_at < '#{dlastyear}'", :order => "id DESC", :limit => 10)
    users.each do |user|
      puts "old user = " + user.email + " and updated_at: " + user.updated_at.to_s 

      

    end

  end
  #######
  # END 1. delete any data for users who have not had activity for 1 year
  # 
  #######

  puts "end of script"

end