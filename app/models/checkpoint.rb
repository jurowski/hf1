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

        old_status = self.status
        new_status = status

        self.status = status
        self.comment = comment
        self.save
        if self.goal != nil
            ### it would be nil if the goal had been deleted w/out the checkpoints being deleted
            ### this does seem to happen somehow now and then


            #### UPDATE IMPACT POINTS FOR USER
            if !self.goal.user.impact_points
              self.goal.user.impact_points = 0
            end
            if new_status == "yes" and (old_status != "yes") and (old_status != "no")
              self.goal.user.impact_points += 5
            end


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


        begin 
          ### attempt to add to encourage_items


          # when a checkpoint is updated,
          # if username != unknown,
          # if it is a yes, and if the goal is public,
          # then enter it into encourage_items

          # --- encourage_item ---
          # encourage_type_new_checkpoint_bool (index)
          # encourage_type_new_goal_bool (index)
          # checkpoint_id
          # checkpoint_status
          # checkpoint_date (index)
          # checkpoint_updated_at_datetime
          # goal_id (index)
          # goal_name
          # goal_category
          # goal_created_at_datetime
          # goal_publish
          # goal_first_start_date (index)
          # goal_daysstraight
          # goal_days_into_it
          # goal_success_rate_percentage
          # user_id (index)
          # user_name
          # user_email

          logger.debug "sgj:checkpoint.rb:consider adding to encourage_items"
          if self.status == "yes"
            if self.checkin_date >= self.goal.user.dyesterday
              if self.goal.user.first_name != "unknown"
                if self.goal.is_public
                  logger.debug "sgj:checkpoint.rb:candidate for encourage_items"

                  encourage_item = EncourageItem.new
                  logger.debug "sgj:checkpoint.rb:new encourage_items instantiated"

                  encourage_item.encourage_type_new_checkpoint_bool = true
                  encourage_item.encourage_type_new_goal_bool = false
                  encourage_item.checkpoint_id = self.id
                  encourage_item.checkpoint_status = self.status
                  encourage_item.checkpoint_date = self.checkin_date
                  encourage_item.checkpoint_updated_at_datetime = self.updated_at
                  encourage_item.goal_id = self.goal.id
                  encourage_item.goal_name = self.goal.title
                  encourage_item.goal_category = self.goal.category
                  encourage_item.goal_created_at_datetime = self.goal.created_at
                  encourage_item.goal_publish = self.goal.publish
                  encourage_item.goal_first_start_date = self.goal.first_start_date
                  encourage_item.goal_daysstraight = self.goal.daysstraight
                  encourage_item.goal_days_into_it = self.goal.days_into_it
                  encourage_item.goal_success_rate_percentage = self.goal.success_rate_percentage
                  encourage_item.user_id = self.goal.user.id
                  encourage_item.user_name = self.goal.user.first_name
                  encourage_item.user_email = self.goal.user.email

                  logger.debug "sgj:checkpoint.rb:about to save encourage_items"

                  encourage_item.save

                  logger.debug "sgj:checkpoint.rb:saved encourage_item"
                end
              end
            end
          end

        rescue
         logger.error "sgj:error adding to encourage_items"
        end

      rescue
        success = false
       logger.error "sgj:error in update_status(status)"
      end
      return success
  end


end
