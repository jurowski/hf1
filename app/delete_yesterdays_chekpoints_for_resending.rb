require 'active_record'
class UpdateUserNumberActiveGoals < ActiveRecord::Base

  # This script:
  # 1. changes goal statuses to "hold" for those out of date range
  # 2. updates the number of active goals that each user has
  # 3. moves any checkpoints for "held" goals that are XXX days old to expiredcheckpoints
  
  ### Whether to run the above steps
  run_1 = "yes"
  run_2 = "yes"
  run_3 = "yes"
  
  FileUtils.touch 'launched_update_user-number_active_goals_at'
  
  
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
  # START 1. changes goal statuses to "hold" for those out of date range
  # 
  #######
  if run_1 == "yes"
    held = 0
    @goals_expired = Goal.find(:all, :conditions => "stop < '#{dnow}'")
    for goal in @goals_expired
      goal.status = "hold"
      goal.save
      held = held + 1
    end
    puts "placed #{held} goals on hold"    
  end
  #######
  # END 1. changes goal statuses to "hold" for those out of date range
  # 
  #######

  
  
  
  #######
  # START 2. update the number of active goals that each user has
  # 
  #######
  if run_2 == "yes"
    @all_users = User.find(:all)
    for user in @all_users
      goal_count = 0
      @goals_active = Goal.find(:all, :conditions => "user_id = '#{user.id}' and status !='hold'")
      for goal in @goals_active
        goal_count = goal_count + 1
      end
      user.update_number_active_goals = goal_count
      user.save
    end
  end
  #######
  # END 2. update the number of active goals that each user has
  # 
  #######


  #######
  # START 3. moves any checkpoints for "held" goals that are XXX days old to expiredcheckpoints
  # 
  #######
  if run_3 == "yes"
    @goals_held = Goal.find(:all, :conditions => "status = 'hold' and stop < '#{d7daysago}'")
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
  # END 3. moves any checkpoints for "held" goals that are XXX days old to expiredcheckpoints
  # 
  #######

puts "end of script"
FileUtils.touch 'finished_update_user-number_active_goals_at'

end