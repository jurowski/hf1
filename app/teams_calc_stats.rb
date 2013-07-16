require 'active_record'
require 'logger'

class TeamsCalcStats < ActiveRecord::Base

  # This script is used to calculate team stats


  teams = Team.find(:all)
  for team in teams



      goals = Goal.find(:all, :conditions => "team_id = #{team.id}")
      if goals != nil

        count_of_7 = 0
        count_of_14 = 0
        count_of_21 = 0
        count_of_30 = 0
        count_of_60 = 0
        count_of_90 = 0
        count_of_180 = 0
        count_of_270 = 0
        count_of_365 = 0

        sum_of_7 = 0
        sum_of_14 = 0
        sum_of_21 = 0
        sum_of_30 = 0
        sum_of_60 = 0
        sum_of_90 = 0
        sum_of_180 = 0
        sum_of_270 = 0
        sum_of_365 = 0

        avg_of_7 = nil
        avg_of_14 = nil
        avg_of_21 = nil
        avg_of_30 = nil
        avg_of_60 = nil
        avg_of_90 = nil
        avg_of_180 = nil
        avg_of_270 = nil
        avg_of_365 = nil


        # output = "TEAM: team with id " + team.id.to_s + " has " + current_size.to_s + " members "
        # puts output
        # logger.debug(output)

        for goal in goals

            if goal.success_rate_during_past_7_days
                count_of_7 += 1
                sum_of_7 += goal.success_rate_during_past_7_days
                avg_of_7 = sum_of_7/count_of_7
                team.success_rate_during_past_7_days = avg_of_7
            end

            if goal.success_rate_during_past_14_days
                count_of_14 += 1
                sum_of_14 += goal.success_rate_during_past_14_days
                avg_of_14 = sum_of_14/count_of_14
                team.success_rate_during_past_14_days = avg_of_14
            end


            if goal.success_rate_during_past_21_days
                count_of_21 += 1
                sum_of_21 += goal.success_rate_during_past_21_days
                avg_of_21 = sum_of_21/count_of_21
                team.success_rate_during_past_21_days = avg_of_21
            end

            if goal.success_rate_during_past_30_days
                count_of_30 += 1
                sum_of_30 += goal.success_rate_during_past_30_days
                avg_of_30 = sum_of_30/count_of_30
                team.success_rate_during_past_30_days = avg_of_30
            end

            if goal.success_rate_during_past_60_days
                count_of_60 += 1
                sum_of_60 += goal.success_rate_during_past_60_days
                avg_of_60 = sum_of_60/count_of_60
                team.success_rate_during_past_60_days = avg_of_60
            end

            if goal.success_rate_during_past_90_days
                count_of_90 += 1
                sum_of_90 += goal.success_rate_during_past_90_days
                avg_of_90 = sum_of_90/count_of_90
                team.success_rate_during_past_90_days = avg_of_90
            end

            if goal.success_rate_during_past_180_days
                count_of_180 += 1
                sum_of_180 += goal.success_rate_during_past_180_days
                avg_of_180 = sum_of_180/count_of_180
                team.success_rate_during_past_180_days = avg_of_180
            end

            if goal.success_rate_during_past_270_days
                count_of_270 += 1
                sum_of_270 += goal.success_rate_during_past_270_days
                avg_of_270 = sum_of_270/count_of_270
                team.success_rate_during_past_270_days = avg_of_270
            end

            if goal.success_rate_during_past_365_days
                count_of_365 += 1
                sum_of_365 += goal.success_rate_during_past_365_days
                avg_of_365 = sum_of_365/count_of_365
                team.success_rate_during_past_365_days = avg_of_365
            end






        end ### end for goal in goals
      end ### end if goals != nil

      team.save

  end ### end for team in teams
  puts "end of script"

  

end
