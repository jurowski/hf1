require "logger"
require "date"
class Checkpoint < ActiveRecord::Base
  belongs_to :goal
  validates_length_of :status, :minimum => 2
  #validates_inclusion_of :status, :in => ["no", "yes", "email sent", "email failure", "email not yet sent", "email queued"]
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
                  encourage_item.goal_momentum = self.goal.momentum

                  if encourage_item.goal_momentum > 74
                    encourage_item.category_image_name = self.goal.category_image(4)
                  else
                    encourage_item.category_image_name = self.goal.category_image(3)
                  end


                  encourage_item.user_id = self.goal.user.id
                  encourage_item.user_name = self.goal.user.first_name
                  encourage_item.user_email = self.goal.user.email

                  logger.debug "sgj:checkpoint.rb:about to save encourage_items"

                  encourage_item.save



                  add_a_random_slacker = false

                  if add_a_random_slacker
                    begin


                      #logger.info "sgj:checkpoint.rb:seek_slacker:1:looking for a SLACKER to add to encourage_items"
                      ### now let's toss in a random person needing help
                      #slacker_goals = arr_random_slacker_goals(1)

                      #logger.info("sgj:checkpoint.rb.rb:arr_random_slacker_goal:1")
                      arr_chosen_goals = Array.new()



                      ### FOR NOW ONLY DO THIS EVERY OTHER TIME
                      limit_size = 2
                      random_number = 0
                      random_number = rand(limit_size) + 0 #between 0 and limit_size

  #logger.info("sgj:random check is random_number = " + random_number.to_s)
                      if random_number == 1 or random_number == 2
  #logger.info("sgj:random YES")
                        keep_looking = true
                        counter = 0
                        max_counter = 1


                        #logger.info("sgj:checkpoint.rb.rb:arr_random_slacker_goal:1.1")
                        #### DEBUG
                        #slacker_goals = Goal.find(:all, :conditions => "publish = '1' and status <> 'hold' and laststatusdate > '#{self.goal.user.dtoday - 30}'")
                        #logger.info("sgj:checkpoint.rb.rb:arr_random_slacker_goal:1.2")
                        #### LIVE
                        slacker_goals = Goal.find(:all, :conditions => "publish = '1' and status <> 'hold' and laststatusdate > '#{self.goal.user.dtoday - 30}' and laststatusdate < '#{self.goal.user.dtoday - 7}'")
                        #logger.info("sgj:checkpoint.rb.rb:1.3")
                        if slacker_goals
                          # logger.info("sgj:yes found some")
                          slacker_goals.each do |slacker_goal|
                            # logger.info("sgj:going to look at one now")
                            # logger.info("sgj:checkpoint.rb.rb:arr_random_slacker_goal:3:looking at slacker_goal.title of " + slacker_goal.title)
                            break if !keep_looking
                            random_index = rand(slacker_goals.size) #between 0 and (size - 1)
                            slacker_goal = slacker_goals[random_index]

                            # logger.info("sgj:checkpoint.rb.rb:arr_random_slacker_goal:3.1:about to see if free user")

                            ### do this for Free users only (to keep them involved)
                            #if slacker_goal and slacker_goal.user and !slacker_goal.user.is_habitforge_supporting_member

                            ### do this for all users
                            if slacker_goal and slacker_goal.user
                              # logger.info("sgj:checkpoint.rb.rb:arr_random_slacker_goal:4:about to check if user has name")
                              if slacker_goal.user.first_name != "unknown" and !arr_chosen_goals.include? slacker_goal.id
                                arr_chosen_goals << slacker_goal.id
                                counter = counter + 1
                                if counter == max_counter
                                  keep_looking = false
                                end

                              end ### end if slacker goal user has a real name (vs. unknown)
                            end ### end if there's still a slacker goal
                          end ### end each slacker goal
                        else
                          logger.error("sgj:checkpoint.rb:arr_random_slacker_goal:4:no slacker goals found")
                        end ### end all slacker goals






                        # logger.debug("sgj:checkpoint.rb:seek_slacker:2:just got back from getting slacker_goals")
                        # logger.info("sgj:checkpoint.rb:going to look for arr_chosen_goals[0] of " + arr_chosen_goals[0].to_s)
                        focus_slacker_goal = Goal.find(arr_chosen_goals[0])
                        # logger.info("sgj:checkpoint.rb:found focus_slacker_goal.id of " + focus_slacker_goal.id.to_s + " and title = " + focus_slacker_goal.title)

                        if focus_slacker_goal
                          encourage_item_slack = EncourageItem.new
                          # logger.info "sgj:checkpoint.rb:seek_slacker:3:new SLACKER encourage_items instantiated"

      # logger.info("sgj:1")
                          encourage_item_slack.encourage_type_new_checkpoint_bool = false
      # logger.info("sgj:1.1")
                          encourage_item_slack.encourage_type_new_goal_bool = false
      # logger.info("sgj:1.2")
                          encourage_item_slack.goal_id = focus_slacker_goal.id
      # logger.info("sgj:1.3")                      
                          #encourage_item_slack.checkpoint_status = self.status
      # logger.info("sgj:1.4")
                          encourage_item_slack.checkpoint_date = self.checkin_date
      # logger.info("sgj:1.5")
                          encourage_item_slack.checkpoint_updated_at_datetime = self.updated_at
      # logger.info("sgj:1.6")
                          encourage_item_slack.checkpoint_id = self.id ### this has to be unique scoped to goal_id
      # logger.info("sgj:2")
                          encourage_item_slack.goal_name = focus_slacker_goal.title
                          encourage_item_slack.goal_category = focus_slacker_goal.category
                          encourage_item_slack.goal_created_at_datetime = focus_slacker_goal.created_at
                          encourage_item_slack.goal_publish = focus_slacker_goal.publish
                          encourage_item_slack.goal_first_start_date = focus_slacker_goal.first_start_date
                          encourage_item_slack.goal_daysstraight = focus_slacker_goal.daysstraight
                          encourage_item_slack.goal_days_into_it = focus_slacker_goal.days_into_it
      # logger.info("sgj:3")
                          encourage_item_slack.goal_success_rate_percentage = focus_slacker_goal.success_rate_percentage
                          encourage_item_slack.goal_momentum = focus_slacker_goal.momentum
                          encourage_item_slack.user_id = focus_slacker_goal.user.id
                          encourage_item_slack.user_name = focus_slacker_goal.user.first_name
                          encourage_item_slack.user_email = focus_slacker_goal.user.email

                          # logger.debug "sgj:checkpoint.rb:about to save SLACKER encourage_items"

      # logger.info("sgj:4")
                          encourage_item_slack.save
      # logger.info("sgj:5")
                        end ### end if slacker_goal

                      end ### end if slacker_goals

                    rescue
                      logger.error("sgj:checkpoint.rb:error while trying to save a random SLACKER on checkpoint update")
                    end

                  end ### if add_a_random_slacker


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
