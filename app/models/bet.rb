class Bet < ActiveRecord::Base
  belongs_to :betpayee
  belongs_to :goal
  belongs_to :user  

  attr_accessor :success_rate_dynamic, :min_success_days_to_win, :number_successful_days_in_this_bet, :number_checkpoints_in_this_bet

  def min_success_days_to_win
      min = 0

      begin
        ### Determine minimum days needed to succeed, and round up!
        floor_days = ((self.floor + 0.0)/100) * self.length_days
        floor_days_mod = floor_days.floor
        if floor_days > floor_days_mod
            floor_days = (floor_days_mod + 1)
        end
        floor_days = floor_days.floor
        
        min = floor_days
      rescue
          logger.error "SGJ error in bet model min_success_days_to_win"
      end
      return min
  end

  def number_successful_days_in_this_bet
    count = 0
    begin
        checkpoints_yes = Checkpoint.find(:all, :conditions => "status = 'yes' and goal_id = '#{self.goal.id}' and checkin_date >= '#{self.start_date}' and checkin_date <= '#{self.end_date}'")        
        count = checkpoints_yes.size
    rescue
        logger.error "SGJ error in bet.successful_days"
    end
    return count
  end

  def number_checkpoints_in_this_bet
    count = 0
    if self.checkpoints_in_this_bet.size != nil
        count = self.checkpoints_in_this_bet.size
    end      
    return count
  end

  def checkpoints_in_this_bet
    checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.goal.id}' and checkin_date >= '#{self.start_date}' and checkin_date <= '#{self.end_date}'")
  end

  def success_rate_dynamic
    success_rate = 0
    begin
        if number_checkpoints_in_this_bet > 0
            success_rate = (((number_successful_days_in_this_bet + 0.0) / self.checkpoints_in_this_bet.size)*100).floor 
        end
    rescue
        logger.error "SGJ error in bet.success_rate_dynamic"
    end
    return success_rate
    
  end
      
end
