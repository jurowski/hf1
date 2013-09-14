require 'active_record'
class UpdateUserNumberGoalsIFollow < ActiveRecord::Base

  # This script:
  # 1. updates whether the user follows any active goals

  ### Whether to run the above steps
  run_1 = "yes" ### just do this manually when needed
  
  ### Careful, the below can kill if running from terminal and not cron
  #FileUtils.touch 'tmp/launched_update_user-number_active_goals_at'
  
  
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
  d21daysago = dnow - 21
  ######
  
  
  #######
  # START 1. updates whether the user follows any active goals
  # 
  #######
  if run_1 == "yes"
      
    puts "Going to update whether users follow any active goals"

    ### If you iterate through all users at once you will bloat and kill the PID
    ### so instead, cut them up by user.active_goals_tallied_hour
    counter = 0
    batch = 0
    active_user_count = 0
    active_goal_count = 0
    per_run_limit = 1000
    batch_size = 1 ### something greater than 0 to start
    #max_batches = 20
    
    ### for some reason doing max_batches didn't work as expected ??
    #while (batch_size > 0) and (batch <= max_batches)
    while batch_size > 0
        batch = batch + 1
        puts "-----  BATCH #{batch} of qty #{per_run_limit} ------"
        @all_users = User.find(:all, :limit => per_run_limit, :conditions => "(active_goals_i_follow_tallied_date is null or active_goals_i_follow_tallied_date != #{dnow})")
        batch_size = @all_users.size 
        for user in @all_users
          goal_count = 0
          cheers = Cheer.find(:all, :conditions => "email = '#{user.email}'")

          for cheer in cheers
            begin

              goal = Goal.find(:first, :conditions => "id = #{cheer.goal_id}")
              #goal = Goal.find(cheer.goal_id)
              if goal
                if goal.is_active
                  goal_count = goal_count + 1
                end
                puts "found goal_id " + cheer.goal_id.to_s
              else
                puts "could not find goal_id " + cheer.goal_id.to_s + " (should delete it)"
              end

            rescue
              puts "error when trying to find goal_id " + cheer.goal_id.to_s
            end
          end
          user.update_number_active_goals_i_follow = goal_count
          user.active_goals_i_follow_tallied_date = dnow
          user.save
          counter = counter + 1
        end
    end

    
  end
  #######
  # END 4. updates whether the user follows any active goals
  # 
  #######
puts "end of script"

### Careful, the below can kill if running from terminal and not cron
#FileUtils.touch 'tmp/finished_update_user-number_active_goals_at'

end
