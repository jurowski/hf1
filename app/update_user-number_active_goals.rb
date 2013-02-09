require 'active_record'
class UpdateUserNumberActiveGoals < ActiveRecord::Base

  # This script:
  # 1. changes goal statuses to "hold" for those out of date range (unless it's an established habit)
  # 2. updates the number of active goals that each user has
  # 3. moves any checkpoints for "held" goals that were never established that are XXX days old to expiredcheckpoints
  # 4. updates whether the user follows any active goals

  ### Whether to run the above steps
  run_1 = "no" ### just do this manually when needed
  run_2 = "yes" ### or just do this manually when needed
  run_3 = "no" ### just do this manually when needed
  run_4 = "yes"
  
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
  # START 1. changes goal statuses to "hold" for those out of date range (unless it's an established habit)
  # 
  #######
  if run_1 == "yes"
    held = 0
    @goals_expired = Goal.find(:all, :conditions => "stop < '#{d21daysago}' and established_on = '1900-01-01' and status !='hold'")
    for goal in @goals_expired
      goal.status = "hold"
      goal.save
      held = held + 1
    end
    puts "placed #{held} goals on hold"    
  end
  #######
  # END 1. changes goal statuses to "hold" for those out of date range (unless it's an established habit)
  # 
  #######

  
  
  
  #######
  # START 2. update the number of active goals that each user has
  # 
  #######
  if run_2 == "yes"
      
    ### If you iterate through all users at once you will bloat and kill the PID
    ### so instead, cut them up by user.active_goals_tallied_hour
    counter = 0
    batch = 0
    active_user_count = 0
    active_goal_count = 0
    per_run_limit = 1000
    batch_size = 1 ### something greater than 0 to start
    #max_batches = 20

    ### for some reason adding in max_batches didn't work as expected ??
    while batch_size > 0
    #while (batch_size > 0) and (batch <= max_batches)
        batch = batch + 1
        puts "-----  BATCH #{batch} of qty #{per_run_limit} ------"
        @all_users = User.find(:all, :limit => per_run_limit, :conditions => "(active_goals_tallied_hour != #{tnow_H})")
        batch_size = @all_users.size 
        for user in @all_users
          goal_count = 0
          @goals_active = Goal.find(:all, :conditions => "user_id = '#{user.id}' and status !='hold' and ((stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))")

          for goal in @goals_active
            goal_count = goal_count + 1
          end
          if goal_count > 0
              active_user_count = active_user_count + 1
              active_goal_count = active_goal_count + goal_count
          end
          user.update_number_active_goals = goal_count
          user.active_goals_tallied_hour = tnow_H
          user.save
          counter = counter + 1
        end
    end

    ############################
    ### SAVE STATS
    ############################
    @stats = Stat.find(:all, :conditions => "recorddate = '#{dnow}' and recordhour = '#{tnow_H}'")
    @stat = Stat.new
    if @stats.size > 0
      for stat in @stats
        @stat =  stat
      end
    else
      @stat.recorddate = dnow
      @stat.recordhour = tnow_H  
    end  
    @stat.activeusercount = active_user_count
    @stat.activegoalcount = active_goal_count
    @stat.save
    ############################
    ############################
    
  end
  #######
  # END 2. update the number of active goals that each user has
  # 
  #######


  #######
  # START 3. moves any checkpoints for "held" goals that were never established that are XXX days old to expiredcheckpoints
  # 
  #######
  if run_3 == "yes"
    @goals_held = Goal.find(:all, :conditions => "status = 'hold' and stop < '#{d7daysago}' and established_on = '1900-01-01'")
    for goal in @goals_held
      @checkpoints_held = Checkpoint.find(:all, :conditions => "goal_id = '#{goal.id}'")
      for checkpoint in @checkpoints_held
        ### copy checkpoint to expiredcheckpoints
        e_check = Expiredcheckpoint.new
        ## checkin_date:date checkin_time:time status:string goal_id:integer created_at:datetime updated_at:datetime comment:text
        
        e_check.checkin_date = checkpoint.checkin_date
        e_check.checkin_time = checkpoint.checkin_time
        e_check.status = checkpoint.status
        e_check.goal_id = checkpoint.goal_id
        e_check.created_at = checkpoint.created_at
        e_check.updated_at = checkpoint.updated_at
        e_check.comment = checkpoint.comment
        e_check.save
        #puts "would have saved e_check"
        
        ### delete checkpoint
        checkpoint.delete
        #puts "would have deleted checkpoint"
      end
    end
  end
  #######
  # END 3. moves any checkpoints for "held" goals that were never established that are XXX days old to expiredcheckpoints
  # 
  #######


  #######
  # START 4. updates whether the user follows any active goals
  # 
  #######
  if run_4 == "yes"
      
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
        @all_users = User.find(:all, :limit => per_run_limit, :conditions => "(active_goals_i_follow_tallied_hour != #{tnow_H})")
        batch_size = @all_users.size 
        for user in @all_users
          goal_count = 0
          cheers = Cheer.find(:all, :conditions => "email = '#{user.email}'")

          for cheer in cheers
            begin
              goal = Goal.find(cheer.goal_id)
              if goal
                if goal.is_active
                  goal_count = goal_count + 1
                end
              end
            rescue
              puts "could not find goal_id " + cheer.goal_id.to_s
            end
          end
          user.update_number_active_goals_i_follow = goal_count
          user.active_goals_i_follow_tallied_hour = tnow_H
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
