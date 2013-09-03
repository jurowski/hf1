require 'active_record'
require 'logger'

class SplitUpTeams < ActiveRecord::Base

  # This script is used to break teams that are too large into smaller teams
  
  # PSEUDOCODE
  #
  #  for each team
  #    get count of goals w/ that team_id
  #    if count > max_team size
  #      set old teamgoal record to inactive
  #      join the goal to a new team where new team_id <> old team_id 

  teams = Team.find(:all)
  for team in teams
      goals = Goal.find(:all, :conditions => "team_id = #{team.id}")
      if goals != nil
        current_size = goals.size
        output = "TEAM: team with id " + team.id.to_s + " has " + current_size.to_s + " members "
        puts output
        logger.debug(output)

        if !team.qty_max
            team.qty_max = 4
            team.save
        end

        for goal in goals
            if current_size > team.qty_max

                output = "TEAM: removing " + goal.id.to_s + " from team " + team.id.to_s
                puts output
                logger.debug(output)
                ### Modify and Save Goal
                goal.team_id = nil
                goal.save
                
                ### De-activate teamgoal
                teamgoal = Teamgoal.find(:first, :conditions => "goal_id = #{goal.id} and team_id = #{team.id} and active = 1")
                if teamgoal != nil
                    teamgoal.active = 0
                    teamgoal.save
                end
                current_size = current_size - 1

                output = "TEAM: current size of team " + team.id.to_s + " is now " + current_size.to_s
                puts output
                logger.debug(output)                
                

                #################################################################    
                #Start Join Team Code
                #################################################################    
                team_with_openings = Team.find(:first, :conditions => "category_name = '#{goal.category}' and has_opening = 1")
                if team_with_openings
                    output = "TEAM: found team_with_openings"
                    puts output
                    logger.debug(output)

                    ### Create a new teamgoal record
                    new_teamgoal = Teamgoal.new()
                    new_teamgoal.team_id = team_with_openings.id
                    new_teamgoal.goal_id = goal.id
                    new_teamgoal.qty_kickoff_votes = 0
                    new_teamgoal.active = 1
                    new_teamgoal.save  
                    
                    ### Modify and Save Team
                    team_with_openings.qty_current = team_with_openings.qty_current + 1 
                    if team_with_openings.qty_current >= team_with_openings.qty_max
                        team_with_openings.has_opening = 0
                    else
                        team_with_openings.has_opening = 1
                    end
                    team_with_openings.save  
                    
                    ### Modify and Save Goal
                    goal.team = team_with_openings
                    goal.save
                else
                    output = "TEAM: no team_with_openings ... create one"
                    puts output
                    logger.debug(output)

                    ### Create a new team
                    new_team = Team.new()
                    new_team.category_name = goal.category
                    new_team.save  
                    
                    ### Add to the new team 
                    ### make sure a record is being inserted to teamgoal 
                    goal.team = new_team
                    goal.save       
                    
                    ### Modify and Save Team
                    new_team.qty_max = 4
                    new_team.qty_current = 1
                    new_team.has_opening = 1
                    new_team.save  
                    
                    
                    ### Create a new teamgoal record
                    new_teamgoal = Teamgoal.new()
                    new_teamgoal.team_id = new_team.id
                    new_teamgoal.goal_id = goal.id
                    new_teamgoal.qty_kickoff_votes = 0
                    new_teamgoal.active = 1
                    new_teamgoal.save  
                end  
                #################################################################
                #END Join Team code    
                #################################################################
            end
        end
      end
  end
  puts "end of script"

  

end
