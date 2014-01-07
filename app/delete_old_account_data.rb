require 'active_record'
class DeleteOldAccountData < ActiveRecord::Base



################ DANGER DANGER DANGER
################ DANGER DANGER DANGER################ DANGER DANGER DANGER################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER

################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER



##################

# WE HAVE AT LEAST ONE DOCUMENTED CASE
# OF A USER ACCOUNT WHO WAS PURGED
# BY THIS SCRIPT
# WHO WAS STILL VERY ACTIVE
# AND HAD BEEN FOR 3.5 YEARS

# BECAUSE WE WERE LOOKING AT USER.last_request_at INSTEAD OF USER.LAST_ACTIVITY_DATE



##################





################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER

### RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/update_user-number_active_goals.rb
#RAILS_ENV=production 
#/usr/bin/ruby 
#/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
#/home/jurowsk1/etc/rails_apps/habitforge/current/app/update_user-number_active_goals.rb

  # This script:
  # deletes any user data for users who have not had activity in 1 year
  # and who are not paid users

  ### Whether to run the above steps
  run_1 = "no"

  
  
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
  d6monthsago = dnow - 180
  dlastweek = dnow - 7
  ######
    


  #######
  # START 1. delete any data for users who have not had activity for 1 year
  # 
  #######
  if run_1 == "yes"

    limit = 10

    #datelimit = dlastyear
    datelimit = d6monthsago


    ### can't use "updated_at" since any user migration changes that for all
    users = User.find(:all, :conditions => "kill_ads_until is null and last_request_at < '#{datelimit}' and last_activity_date < '#{datelimit}'", :order => "id DESC", :limit => "#{limit}")

    users.each do |user|
      c = "old user = " + user.email + " and last_request_at: " + user.last_request_at.to_s + " and last_activity_date: " + user.last_activity_date.to_s
      puts c
      logger.info("sgj:delete_old_account_data.rb:" + c )
      keep_user = false

      if user.number_of_active_habits == 0 and user.number_of_templates_i_own == 0
        user.all_goals.each do |goal|

          if !goal.template_owner_is_a_template
            goal.checkpoints.each do |checkpoint|              

              ### DANGER SEE NOTE AT TOP
              #checkpoint.delete
              c = "checkpoint deleted"
              puts c
              logger.info("sgj:delete_old_account_data.rb:" + c )
            end
            c = "deleting goal" + goal.title
            puts c
            logger.info("sgj:delete_old_account_data.rb:" + c )

            ### DANGER SEE NOTE AT TOP
            #goal.delete
          else
            keep_user = true
          end

        end


      else
        c = "!!!!!!!!!!!!! THIS USER DOES ACTUALLY HAVE ACTIVE HABITS !!!!!"
        c = c + "!!!!!!!!!!!!! OR THEY HAVE TEMPLATES THAT THEY OWN !!!!!"
        puts c
        logger.info("sgj:delete_old_account_data.rb:" + c )


      end
      
      if !keep_user
        c = "deleting user" + user.email
        c = c + "-----------------------------------------------"

        puts c
        logger.info("sgj:delete_old_account_data.rb:" + c )
        

        ### DANGER SEE NOTE AT TOP 
        #user.delete

      end
    end ### end users.each do |user|

  end
  #######
  # END 1. delete any data for users who have not had activity for 1 year
  # 
  #######

  puts "end of script"

end