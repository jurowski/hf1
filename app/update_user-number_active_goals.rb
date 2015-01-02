require 'active_record'
class UpdateUserNumberActiveGoals < ActiveRecord::Base

  # This script:
  # 1. changes goal statuses to "hold" for those out of date range (unless it's an established habit)

  #### NOTE THAT THIS SHOULD REALLY BE RUN PRETTY OFTEN LIKE EVERY HOUR SINCE IT ONLY DOES 1K PER HOUR
  # 2. updates the number of active goals that each user has

  # 3. moves any checkpoints for "held" goals that were never established that are XXX days old to expiredcheckpoints
  # 4. updates whether the user follows any active goals
  # 5. creates a program_enrollment record if an active goal was created via a program

  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/update_user-number_active_goals.rb


  ### Whether to run the above steps
  run_1 = "no" ### just do this manually when needed
  run_2 = "yes" ### or just do this manually when needed
  run_3 = "no" ### just do this manually when needed
  run_5 = false
  run_6 = true


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
        @all_users = User.find(:all, :limit => per_run_limit, :conditions => "last_activity_date > '#{dnow - 30}' and (active_goals_tallied_hour is null or active_goals_tallied_hour != #{tnow_H})")
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
    puts counter.to_s + " users were updated this hour"
    

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

  ########################################
  ########################################
  ### 5. create a program enrollment record if a program is involved
  ########################################
  if run_5

    ### should not need to run this more than once, now that
    ### program_enrollment records are created as needed on goal/new

    ####################################################################
    ####################################################################
    #####     PROGRAM ENROLLMENT
    ####################################################################

    program_enrollment_counter = 0
    @active_users = User.find(:all, :conditions => "update_number_active_goals > 0")
    for user in @active_users
      goal_count = 0
      goals_active = Goal.find(:all, :conditions => "user_id = '#{user.id}' and status !='hold' and ((stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))")
      goals_active.each do |goal|
        ### create a program enrollment record if a program is involved
        ### goal and program are linked via goal.goal_added_through_template_from_program_id
        if goal.program
          enrollment = ProgramEnrollment.new()
          # t.integer  "program_id"
          # t.integer  "user_id"
          # t.boolean  "active"
          # t.boolean  "ongoing"
          # t.integer  "program_session_id"
          # t.date     "personal_start_date"
          # t.date     "personal_end_date"
          enrollment.program_id = goal.program.id
          enrollment.user_id = goal.user.id
          enrollment.active = true
          enrollment.ongoing = true

          enrollment.save
          program_enrollment_counter += 1
        end
        ####################################################################
        #####     END PROGRAM ENROLLMENT
        ####################################################################
        ####################################################################
      end ## end each active goal
    end ## end each active user

  end ### end if run_5
  ########################################
  ### END 5. create a program enrollment record if a program is involved
  ########################################
  ########################################



  ########################################
  ########################################
  ### 6. save a program's number of enrolled users
  ########################################
  if run_6

    programs = Program.find(:all)
    programs.each do |program|
      program.count_of_enrolled_users = program.program_enrollments.size
      program.save
    end

  end ### end if run_6
  ########################################
  ### END 6. save a program's number of enrolled users
  ########################################
  ########################################


puts "end of script"

### Careful, the below can kill if running from terminal and not cron
#FileUtils.touch 'tmp/finished_update_user-number_active_goals_at'

end
