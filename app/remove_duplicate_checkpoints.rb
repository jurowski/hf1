require 'active_record'
class RemoveDuplicateCheckpoints < ActiveRecord::Base

  # This script:

  
  ### GET DATE NOW ###
  jump_forward_days = 0
  
  tnow = Time.now
  tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
  tnow_m = tnow.strftime("%m").to_i #month of the year
  tnow_d = tnow.strftime("%d").to_i #day of the month
  tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
  tnow_M = tnow.strftime("%M").to_i #minute of the hour
  #puts tnow_Y + tnow_m + tnow_d  
  #puts "Current timestamp is #{tnow.to_s}"
  dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
  dyesterday = dnow - 1
  ######
  

    checkin_date = '2011-05-16'
    total_removed_all = 0

    goal_id = 0
    #goal_id = 25840
    
    if goal_id == 0
        ### FIND ALL ACTIVE GOALS
        @goals = Goal.find(:all, :conditions => "stop >= '#{dnow}' and status !='hold'")
    else
        ### JUST RUN ON ONE GOAL
        @goals = Goal.find(:all, :conditions => "id = '#{goal_id}'")
    end
    for goal in @goals

        total_removed_goal = 0
        
        ### Remove duplicate entries that were answered 
        @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal.id}' and checkin_date = '#{checkin_date}' and (status = 'yes' or status = 'no')")
        if @checkpoints.size > 1
            remove_this_many = @checkpoints.size - 1
            number_removed = 0
            for checkpoint in @checkpoints
                if number_removed < remove_this_many
                    checkpoint.delete
                    total_removed_goal = total_removed_goal + 1
                    number_removed = number_removed + 1
                end
            end
        end

        ### If left w/ a mix of answer and no answer, remove any no-answers 
        @checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal.id}' and checkin_date = '#{checkin_date}'")
        if @checkpoints.size > 1
            remove_this_many = @checkpoints.size - 1
            number_removed = 0
            for checkpoint in @checkpoints
                if number_removed < remove_this_many
                    if checkpoint.status != 'yes' and checkpoint.status != 'no'
                        checkpoint.delete
                        total_removed_goal = total_removed_goal + 1
                        number_removed = number_removed + 1
                    end
                end
            end
        end
        
        
        if total_removed_goal > 0
            puts "For #{goal.id.to_s}, removed #{total_removed_goal.to_s} duplicates."
        end

        total_removed_all = total_removed_all + total_removed_goal

    end
    
    puts "Total duplicates removed via script: #{total_removed_all.to_s}"

end
