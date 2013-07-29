require 'active_record'
class DeleteOldEncourageItems < ActiveRecord::Base


  ### RUN IN PRODUCTION:
  ### RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/delete_old_encourage_items.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/delete_old_encourage_items.rb


  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/delete_old_encourage_items.rb

  ### THIS SCRIPT:
  # removes any "encourage_items"
  # that have a created_at of > 3 days,


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
  d_3_days_ago = dnow - 3
  ######
    
  log = "sgj:delete_old_encourage_items.rb:START_SCRIPT"
  puts log
  logger.info(log)


  begin
    #######
    # START 1. delete any encourage_items that were created_at > 3 days ago
    # 
    #######
    if run_1 == "yes"

      limit = 1000
      really_delete = true

      items = EncourageItem.find(:all, :conditions => "created_at < '#{d_3_days_ago}'", :order => "id DESC", :limit => "#{limit}")

      items.each do |item|
        log = "sgj:delete_old_encourage_items.rb:about to delete old encourage_item created_at = " + item.created_at.to_s
        puts log
        logger.info(log)

        if really_delete        
          item.delete
        end
      end ### end items.each do |item|

    end
    #######
    # END 1. delete any encourage_items that were created_at > 3 days ago
    # 
    #######

  rescue


    script = "delete_old_encourage_items.rb"
    log = "sgj:delete_old_encourage_items.rb:ERROR WHILE RUNNING SCRIPT (sending email to support)"
    puts log
    logger.info(script, log)

    Notifier.deliver_notify_support_script_error(script, log) # sends the email  

  end

  log = "sgj:delete_old_encourage_items.rb:END_SCRIPT"
  puts log
  logger.info(log)

end