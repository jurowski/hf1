require 'active_record'
require 'date'
require 'logger'

class RemoveSlackersFromTeams < ActiveRecord::Base

  # This script removes slackers from teams
  # (if never answered, after 4 days)
  # (if no answer after 10 days)
  # 
  # Re-calculates the team sizes (in case they're off)

  total_removed = 0
  total_never_checked_in = 0
  total_no_checkins_for_ten_days = 0
  total_goal_does_not_exist = 0

  #testing_dont_actually_delete = true
  testing_dont_actually_delete = false

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
  four_days_ago = dnow - 4
  ten_days_ago = dnow - 10
  ######
  
  ###########################################
  ###      REMOVE TEAM_ID FROM HOLD GOALS ###
  holdgoals = Goal.find(:all, :conditions => "team_id > 0 and status = 'hold'")
  for goal in holdgoals
    goal.team_id = nil
    goal.save
  end
  ###  END REMOVE TEAM_ID FROM HOLD GOALS ###
  ###########################################


  #######################################
  ###      REMOVE SLACKERS            ###
  @teamgoals = Teamgoal.find(:all, :conditions => "active = 1")
  for teamgoal in @teamgoals
    remove_from_team = false
    goal = Goal.find(:first, :conditions => "id = '#{teamgoal.goal_id}'")
    if goal == nil
        ### Remove from team if that goal is now dead
        remove_from_team = true
        total_goal_does_not_exist = total_goal_does_not_exist + 1
    else
        ### Remove slackers from teams
        if goal.laststatusdate == nil
          #Remove if never checked in after 4 days
          if goal.start < four_days_ago
            remove_from_team = true
            puts "#{four_days_ago} (4 days ago) was the start but they never checked in"
            total_never_checked_in = total_never_checked_in + 1
          end
        else
          #Remove if no checkins for 10 days
          if goal.laststatusdate < ten_days_ago
            remove_from_team = true
            puts "#{goal.laststatusdate} is too old of a checkin (older than 10 days ago)"
            total_no_checkins_for_ten_days = total_no_checkins_for_ten_days + 1
          end
        end 
    end
    if remove_from_team
        if testing_dont_actually_delete
            puts "testing only, otherwise would have deleted teamgoal #{teamgoal.id} for goal_id #{teamgoal.goal_id}"
        else
            team = Team.find(:first, :conditions => "id = '#{teamgoal.team_id}'")            
            if team
                puts "will adjust team size"
                team.qty_current = team.qty_current - 1 
                if team.qty_current < 0
                    team.qty_current = 0
                end 
                if team.qty_current >= team.qty_max
                    team.has_opening = 0
                else
                    team.has_opening = 1
                end
                team.save  
            end  
            
            puts "will delete teamgoal for nil goal of #{teamgoal.goal_id}"
            teamgoal.destroy

            #puts "will de-activate teamgoal for goal of #{teamgoal.goal_id}"
            #teamgoal.active = 0
            t#eamgoal.save      

            ### Modify and Save Goal
            goal.team_id = nil
            goal.save

        end
        total_removed = total_removed + 1
    end
    
  end
  puts "total_goal_does_not_exist = #{total_goal_does_not_exist}"
  puts "total_never_checked_in = #{total_never_checked_in.to_s}"
  puts "total_no_checkins_for_ten_days = #{total_no_checkins_for_ten_days.to_s}"
  if testing_dont_actually_delete
      puts "testing only, but would have removed total of = #{total_removed.to_s}"
  else
      puts "total_removed = #{total_removed.to_s}"
  end

  ##########
  ### REMOVE ANY OLD INACTIVE TEAMGOAL RECORDS
  ### REMOVE ANY INACTIVE GOALS FROM TEAM
  inactive_teamgoals = Teamgoal.find(:all, :conditions => "active != '1' ")
  inactive_teamgoals.each do |teamgoal|
    goal = Goal.find(teamgoal.goal_id)
    if goal
      goal.team_id = nil
      goal.save
    end
    teamgoal.delete
  end
  ##########

  ### END REMOVE SLACKERS ###
  #######################################


  
  #######################################
  #### ADJUST TEAM SIZE IF INCORRECT ####
  @teams = Team.find(:all)
  for team in @teams
    team_size = 0
    @teamgoals = Teamgoal.find(:all, :conditions => "team_id = '#{team.id}' and active = '1'")
    if @teamgoals != nil

        team_size = @teamgoals.size
        if team_size != team.qty_current
            puts "team size is incorrect @ #{team.qty_current}... adjusting team size to #{team_size}"

            team.qty_current = team_size
            if team.qty_current >= team.qty_max
                team.has_opening = 0
            else
                team.has_opening = 1
            end
            team.save          
        end
    end
  end
  #### END ADJUST TEAM SIZE IF INCORRECT ####
  ###########################################




  
  puts "end of script"

  

end
