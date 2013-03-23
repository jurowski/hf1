require "logger"
class Checkpoint < ActiveRecord::Base
  belongs_to :goal
  validates_length_of :status, :minimum => 2
  validates_inclusion_of :status, :in => ["no", "yes", "email sent", "email failure", "email not yet sent", "email queued"]
  validates_uniqueness_of :checkin_date, :scope => :goal_id

  def update_status(status, comment = "")
      if self.goal
        if status == "yes"
          logger.info("sgj:checkpoint.rb:update_status: " + self.goal.user.first_name + " succeeded at " + self.goal.title + " on " + self.checkin_date.to_s)
        else
          logger.info("sgj:checkpoint.rb:update_status: " + self.goal.user.first_name + " did not succeed with " + self.goal.title + " on " + self.checkin_date.to_s)
        end
      end
      
      success = true
      begin    
        self.status = status
        self.comment = comment
        self.save
        if self.goal != nil
            ### it would be nil if the goal had been deleted w/out the checkpoints being deleted
            ### this does seem to happen somehow now and then

            #logger.info("sgj:checkpoint.rb:create_checkpoints_where_missing")        
            self.goal.create_checkpoints_where_missing

            self.goal.remove_if_duplicates(self.checkin_date)
            self.goal.update_last_status_and_date(self)
            self.goal.reset_start_date_if_needed
            self.goal.update_daysstraight
            self.goal.update_longest_run
            self.goal.update_if_habit_established
            #logger.info("sgj:checkpoint.rb:update_stats START")        
            self.goal.update_stats ### also updates last_stats_badge
            #logger.info("sgj:checkpoint.rb:update_stats BACK")        
            self.goal.auto_extend_3_weeks_if_monitoring
            self.goal.update_bets_success_rates

            ### update last activity date
            self.goal.user.last_activity_date = self.goal.user.dtoday
            self.goal.user.save
        else
            success = false
        end
      rescue
        success = false
        logger.error "SGJ:error in update_status(status)"
      end
      return success
  end


end
