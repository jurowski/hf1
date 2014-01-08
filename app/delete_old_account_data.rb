require 'active_record'
class DeleteOldAccountData < ActiveRecord::Base



################ DANGER DANGER DANGER
################ DANGER DANGER DANGER################ DANGER DANGER DANGER################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER

################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER



##################

# WE HAVE AT LEAST ONE DOCUMENTED CASE
# OF A USER ACCOUNT WHO WAS PURGED
# BY THIS SCRIPT
# WHO WAS STILL VERY ACTIVE
# AND HAD BEEN FOR 3.5 YEARS

# BECAUSE WE WERE LOOKING AT USER.last_request_at INSTEAD OF USER.LAST_ACTIVITY_DATE



##################





################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER
################ DANGER DANGER DANGER

  ### RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/delete_old_account_data.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/delete_old_account_data.rb


  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/delete_old_account_data.rb

  # This script:
  # deletes any user data for users who have not had activity in 1 year
  # and who are not paid users

  ### Whether to run the above steps
  run_1 = "yes"

  ### whether to notify users that they'll be removed soon
  run_0 = "yes"
  
  
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
  dlastyear = dnow - 365
  d6monthsago = dnow - 180
  dlastweek = dnow - 7
  ######


  ### datelimit = how much inactivity will be tolerated before deletion    
  #datelimit = dlastyear
  datelimit = d6monthsago
  inactivity_period_human = "6 months"

  ### grace_days = how many days from now their account will be removed unless they act
  grace_days = 7
  grace_days_human = "7 days"

  ## deletion_warning = the actual date that their account will be removed unless they act
  deletion_warning = dnow + grace_days


  #######
  # START 0.1 notify any users that their account will be removed at a
  # date near in the future if they do not take action
  #######
  if run_0 == "yes"




    limit = 10

    ### can't use "updated_at" since any user migration changes that for all
    users = User.find(:all, :conditions => "kill_ads_until is null and last_request_at < '#{datelimit}' and last_activity_date < '#{datelimit}' and deletion_warning is null", :order => "id DESC", :limit => "#{limit}")

    users.each do |user|

      if user.number_of_active_habits == 0 and user.number_of_templates_i_own == 0

        u = "Notify old user = " + user.email + " and last_request_at: " + user.last_request_at.to_s + " and last_activity_date: " + user.last_activity_date.to_s
        puts u
        logger.info("sgj:delete_old_account_data.rb:" + u )

        Notifier.deliver_user_deletion_soon_notification(user, inactivity_period_human, grace_days_human)

        user.deletion_warning = deletion_warning
        user.save


      end ### end user.number_of_active_habits == 0 and user.number_of_templates_i_own == 0

    end ### end each user

  end ### end if run_0 == "yes"


  #######
  # START 1. delete any data for users who have not had activity for 1 year
  # 
  #######
  if run_1 == "yes"

    limit = 10


    ### can't use "updated_at" since any user migration changes that for all
    users = User.find(:all, :conditions => "kill_ads_until is null and last_request_at < '#{datelimit}' and last_activity_date < '#{datelimit}' and deletion_warning <= '#{dnow}'", :order => "id DESC", :limit => "#{limit}")

    users.each do |user|
      c = "old user = " + user.email + " and last_request_at: " + user.last_request_at.to_s + " and last_activity_date: " + user.last_activity_date.to_s
      puts c
      logger.info("sgj:delete_old_account_data.rb:" + c )
      keep_user = false

      continue_with_goal_copy_and_removal = true

      if user.number_of_active_habits == 0 and user.number_of_templates_i_own == 0
        user.all_goals.each do |goal|


          if !goal.template_owner_is_a_template
            goal.checkpoints.each do |checkpoint|              

              if continue_with_goal_copy_and_removal

                c = "creating copy of checkpoint"
                puts c
                logger.info("sgj:delete_old_account_data.rb:" + c )                

                c_copy = Checkpoint_removed.new
                c_copy.checkpoint_id = checkpoint.id

                c_copy.deleted_by = "delete_old_account_data.rb"
                c_copy.deleted_on = dnow

                c_copy.checkin_date = checkpoint.checkin_date
                c_copy.checkin_time = checkpoint.checkin_time
                c_copy.status = checkpoint.status
                c_copy.goal_id = checkpoint.goal_id
                c_copy.created_at = checkpoint.created_at
                c_copy.updated_at = checkpoint.updated_at
                c_copy.comment = checkpoint.comment
                c_copy.syslognote = checkpoint.syslognote

                if c_copy.save
                  checkpoint.delete
                  c = "copy made, checkpoint deleted"
                  puts c
                  logger.info("sgj:delete_old_account_data.rb:" + c )
                else ### whether c_copy.save
                  continue_with_goal_copy_and_removal = false

                  c = "error creating copy of checkpoint, not deleting checkpoint"
                  puts c
                  logger.info("sgj:delete_old_account_data.rb:" + c )                
                end ### end if c_copy.save

              end ### end if continue_with_goal_copy_and_removal (checkpoint level)

            end ### end for each checkpoint



            if continue_with_goal_copy_and_removal ### goal level
              g = "creating copy of goal"
              puts g
              logger.info("sgj:delete_old_account_data.rb:" + g )                

              g_copy = Goal_removed.new

              g_copy.goal_id = goal.id
              g_copy.deleted_by = "delete_old_account_data.rb"
              g_copy.deleted_on = dnow
              g_copy.user_id = goal.user_id
              g_copy.title = goal.title
              g_copy.summary = goal.summary
              g_copy.why = goal.why
              g_copy.start = goal.start
              g_copy.stop = goal.stop
              g_copy.established_on = goal.established_on
              g_copy.category = goal.category
              g_copy.publish = goal.publish
              g_copy.share = goal.share
              g_copy.status = goal.status
              g_copy.response_question = goal.response_question
              g_copy.response_options = goal.response_options
              g_copy.reminder_time = goal.reminder_time
              g_copy.higher_is_better = goal.higher_is_better
              g_copy.created_at = goal.created_at
              g_copy.updated_at = goal.updated_at
              g_copy.daysstraight = goal.daysstraight
              g_copy.laststatus = goal.laststatus
              g_copy.laststatusdate = goal.laststatusdate
              g_copy.pleasure = goal.pleasure
              g_copy.pain = goal.pain
              g_copy.pp_remind = goal.pp_remind
              g_copy.pp_remind_last_date = goal.pp_remind_last_date
              g_copy.gmtoffset = goal.gmtoffset
              g_copy.serversendhour = goal.serversendhour
              g_copy.usersendhour = goal.usersendhour
              g_copy.daym = goal.daym
              g_copy.dayt = goal.dayt
              g_copy.dayw = goal.dayw
              g_copy.dayr = goal.dayr
              g_copy.dayf = goal.dayf
              g_copy.days = goal.days
              g_copy.dayn = goal.dayn
              g_copy.pre_start_days_per_week = goal.pre_start_days_per_week
              g_copy.success_rate_percentage = goal.success_rate_percentage
              g_copy.days_into_it = goal.days_into_it
              g_copy.goal_days_per_week = goal.goal_days_per_week
              g_copy.team_id = goal.team_id
              g_copy.bet_id = goal.bet_id
              g_copy.is_coached = goal.is_coached
              g_copy.coachgoal_id = goal.coachgoal_id
              g_copy.remind_me = goal.remind_me
              g_copy.reminder_send_hour = goal.reminder_send_hour
              g_copy.reminder_last_sent_date = goal.reminder_last_sent_date
              g_copy.longestrun = goal.longestrun
              g_copy.last_stats_badge = goal.last_stats_badge
              g_copy.last_stats_badge_date = goal.last_stats_badge_date
              g_copy.last_stats_badge_details = goal.last_stats_badge_details
              g_copy.more_reminders_enabled = goal.more_reminders_enabled
              g_copy.more_reminders_start = goal.more_reminders_start
              g_copy.more_reminders_end = goal.more_reminders_end
              g_copy.more_reminders_every_n_hours = goal.more_reminders_every_n_hours
              g_copy.more_reminders_last_sent = goal.more_reminders_last_sent
              g_copy.first_start_date = goal.first_start_date
              g_copy.allow_push = goal.allow_push
              g_copy.phrase1 = goal.phrase1
              g_copy.phrase2 = goal.phrase2
              g_copy.phrase3 = goal.phrase3
              g_copy.phrase4 = goal.phrase4
              g_copy.phrase5 = goal.phrase5
              g_copy.last_success_date = goal.last_success_date
              g_copy.next_push_on_or_after_date = goal.next_push_on_or_after_date
              g_copy.pushes_allowed_per_day = goal.pushes_allowed_per_day
              g_copy.pushes_remaining_on_next_push_date = goal.pushes_remaining_on_next_push_date
              g_copy.team_summary_send_hour = goal.team_summary_send_hour
              g_copy.team_summary_last_sent_date = goal.team_summary_last_sent_date
              g_copy.check_in_same_day = goal.check_in_same_day
              g_copy.template_owner_is_a_template = goal.template_owner_is_a_template
              g_copy.template_owner_advertise_me = goal.template_owner_advertise_me
              g_copy.template_user_parent_goal_id = goal.template_user_parent_goal_id
              g_copy.achievemint_points_earned = goal.achievemint_points_earned
              g_copy.level_points_earned = goal.level_points_earned
              g_copy.template_current_level_id = goal.template_current_level_id
              g_copy.template_let_user_choose_any_level_bool = goal.template_let_user_choose_any_level_bool
              g_copy.template_let_user_choose_lower_levels_bool = goal.template_let_user_choose_lower_levels_bool
              g_copy.template_on_level_success_go_to_next_goal_bool = goal.template_on_level_success_go_to_next_goal_bool
              g_copy.template_on_level_success_go_to_next_level_bool = goal.template_on_level_success_go_to_next_level_bool
              g_copy.template_on_level_success_stop_goal_bool = goal.template_on_level_success_stop_goal_bool
              g_copy.template_let_user_decide_when_to_move_to_next_goal_bool = goal.template_let_user_decide_when_to_move_to_next_goal_bool
              g_copy.template_next_template_goal_id = goal.template_next_template_goal_id
              g_copy.template_description = goal.template_description
              g_copy.template_tagline = goal.template_tagline
              g_copy.template_next_template_goal_random_bool = goal.template_next_template_goal_random_bool
              g_copy.goal_added_through_template_from_program_id = goal.goal_added_through_template_from_program_id
              g_copy.success_rate_during_past_7_days = goal.success_rate_during_past_7_days
              g_copy.success_rate_during_past_14_days = goal.success_rate_during_past_14_days
              g_copy.success_rate_during_past_21_days = goal.success_rate_during_past_21_days
              g_copy.success_rate_during_past_30_days = goal.success_rate_during_past_30_days
              g_copy.success_rate_during_past_60_days = goal.success_rate_during_past_60_days
              g_copy.success_rate_during_past_90_days = goal.success_rate_during_past_90_days
              g_copy.success_rate_during_past_180_days = goal.success_rate_during_past_180_days
              g_copy.success_rate_during_past_270_days = goal.success_rate_during_past_270_days
              g_copy.success_rate_during_past_365_days = goal.success_rate_during_past_365_days
              g_copy.tracker = goal.tracker
              g_copy.tracker_question = goal.tracker_question
              g_copy.tracker_statement = goal.tracker_statement
              g_copy.tracker_units = goal.tracker_units
              g_copy.tracker_digits_after_decimal = goal.tracker_digits_after_decimal
              g_copy.tracker_standard_deviation_from_last_measurement = goal.tracker_standard_deviation_from_last_measurement
              g_copy.tracker_type_starts_at_zero_daily = goal.tracker_type_starts_at_zero_daily
              g_copy.tracker_target_higher_value_is_better = goal.tracker_target_higher_value_is_better
              g_copy.tracker_set_checkpoint_to_yes_if_any_answer = goal.tracker_set_checkpoint_to_yes_if_any_answer
              g_copy.tracker_set_checkpoint_to_yes_only_if_answer_acceptable = goal.tracker_set_checkpoint_to_yes_only_if_answer_acceptable
              g_copy.tracker_target_threshold_bad1 = goal.tracker_target_threshold_bad1
              g_copy.tracker_target_threshold_bad2 = goal.tracker_target_threshold_bad2
              g_copy.tracker_target_threshold_bad3 = goal.tracker_target_threshold_bad3
              g_copy.tracker_target_threshold_good1 = goal.tracker_target_threshold_good1
              g_copy.tracker_target_threshold_good2 = goal.tracker_target_threshold_good2
              g_copy.tracker_target_threshold_good3 = goal.tracker_target_threshold_good3
              g_copy.tracker_measurement_worst_yet = goal.tracker_measurement_worst_yet
              g_copy.tracker_measurement_best_yet = goal.tracker_measurement_best_yet
              g_copy.tracker_measurement_last_taken_on_date = goal.tracker_measurement_last_taken_on_date
              g_copy.tracker_measurement_last_taken_on_hour = goal.tracker_measurement_last_taken_on_hour
              g_copy.tracker_measurement_last_taken_value = goal.tracker_measurement_last_taken_value
              g_copy.tracker_measurement_last_taken_timestamp = goal.tracker_measurement_last_taken_timestamp
              g_copy.tracker_prompt_after_n_days_without_entry = goal.tracker_prompt_after_n_days_without_entry
              g_copy.tracker_prompt_for_an_initial_value = goal.tracker_prompt_for_an_initial_value
              g_copy.tracker_track_difference_between_initial_and_latest = goal.tracker_track_difference_between_initial_and_latest
              g_copy.tracker_difference_between_initial_and_latest = goal.tracker_difference_between_initial_and_latest


              if g_copy.save
                g = "copy made, goal being deleted: " + goal.title
                puts g
                logger.info("sgj:delete_old_account_data.rb:" + g )

                goal.delete
              else ### whether g_copy.save
                continue_with_goal_copy_and_removal = false

                g = "error creating copy of goal_id " + goal.id.to_s + " ... not deleting goal"
                puts g
                logger.info("sgj:delete_old_account_data.rb:" + g )                


              end ### end if g_copy.save

            end ### end if continue_with_goal_copy_and_removal (goal level)

          else ### whether it is a template
            keep_user = true
          end ### end whether it is a template

        end ### end for each stale goal

      else ### whether still active
        c = "!!!!!!!!!!!!! THIS USER DOES ACTUALLY HAVE ACTIVE HABITS !!!!!"
        c = c + "!!!!!!!!!!!!! OR THEY HAVE TEMPLATES THAT THEY OWN !!!!!"
        puts c
        logger.info("sgj:delete_old_account_data.rb:" + c )
      end #### end whether still active
      


      if !keep_user and continue_with_goal_copy_and_removal



        u = "creating copy of user " + user.email
        puts u
        logger.info("sgj:delete_old_account_data.rb:" + u )                

        u_copy = User_removed.new
        u_copy.user_id = user.id

        u_copy.deleted_by = "delete_old_account_data.rb"
        u_copy.deleted_on = dnow

        u_copy.first_name = user.first_name
        u_copy.last_name = user.last_name
        u_copy.email = user.email
        u_copy.string = user.string
        u_copy.crypted_password = user.crypted_password
        u_copy.password_salt = user.password_salt
        u_copy.persistence_token = user.persistence_token
        u_copy.single_access_token = user.single_access_token
        u_copy.perishable_token = user.perishable_token
        u_copy.login_count = user.login_count
        u_copy.failed_login_count = user.failed_login_count
        u_copy.last_request_at = user.last_request_at
        u_copy.current_login_at = user.current_login_at
        u_copy.last_login_at = user.last_login_at
        u_copy.current_login_ip = user.current_login_ip
        u_copy.last_login_ip = user.last_login_ip
        u_copy.created_at = user.created_at
        u_copy.updated_at = user.updated_at
        u_copy.time_zone = user.time_zone
        u_copy.update_number_active_goals = user.update_number_active_goals
        u_copy.gender = user.gender
        u_copy.yob = user.yob
        u_copy.sponsor = user.sponsor
        u_copy.last_donation_date = user.last_donation_date
        u_copy.donated_so_far = user.donated_so_far
        u_copy.kill_ads_until = user.kill_ads_until
        u_copy.unlimited_goals = user.unlimited_goals
        u_copy.combine_daily_emails = user.combine_daily_emails
        u_copy.payments = user.payments
        u_copy.is_admin = user.is_admin
        u_copy.city = user.city
        u_copy.state = user.state
        u_copy.zip = user.zip
        u_copy.cost_per_period = user.cost_per_period
        u_copy.period = user.period
        u_copy.subscriptionid = user.subscriptionid
        u_copy.subscriptionmessage = user.subscriptionmessage
        u_copy.plan = user.plan
        u_copy.premium_start_date = user.premium_start_date
        u_copy.premium_stop_date = user.premium_stop_date
        u_copy.is_a_coach = user.is_a_coach
        u_copy.coach_id = user.coach_id
        u_copy.sent_expire_warning_on = user.sent_expire_warning_on
        u_copy.sent_expire_notice_on = user.sent_expire_notice_on
        u_copy.opt_in_random_fire = user.opt_in_random_fire
        u_copy.affiliate_id = user.affiliate_id
        u_copy.is_affiliate = user.is_affiliate
        u_copy.active_goals_tallied_hour = user.active_goals_tallied_hour
        u_copy.password_temp = user.password_temp
        u_copy.goal_temp = user.goal_temp
        u_copy.referer = user.referer
        u_copy.supportpoints = user.supportpoints
        u_copy.supportpoints_log = user.supportpoints_log
        u_copy.promo_comeback_last_sent = user.promo_comeback_last_sent
        u_copy.promo_comeback_token = user.promo_comeback_token
        u_copy.undeliverable = user.undeliverable
        u_copy.undeliverable_date_checked = user.undeliverable_date_checked
        u_copy.last_activity_date = user.last_activity_date
        u_copy.show_gravatar = user.show_gravatar
        u_copy.impact_points = user.impact_points
        u_copy.date_of_signup = user.date_of_signup
        u_copy.got_free_membership = user.got_free_membership
        u_copy.feed_filter_show_my_categories_only = user.feed_filter_show_my_categories_only
        u_copy.feed_filter_hide_pmo = user.feed_filter_hide_pmo
        u_copy.country = user.country
        u_copy.country_code = user.country_code
        u_copy.state_code = user.state_code
        u_copy.fb_id = user.fb_id
        u_copy.fb_email = user.fb_email
        u_copy.fb_username = user.fb_username
        u_copy.fb_first_name = user.fb_first_name
        u_copy.fb_last_name = user.fb_last_name
        u_copy.fb_gender = user.fb_gender
        u_copy.fb_timezone = user.fb_timezone
        u_copy.google_user_id = user.google_user_id
        u_copy.google_email = user.google_email
        u_copy.handle = user.handle
        u_copy.hide_feed = user.hide_feed
        u_copy.premium_only_complete_privacy = user.premium_only_complete_privacy
        u_copy.premium_only_default_private_goal = user.premium_only_default_private_goal
        u_copy.deletion_warning = user.deletion_warning


        if u_copy.save
          u = "copy made, user being deleted: " + user.email
          puts u
          logger.info("sgj:delete_old_account_data.rb:" + u )

          user.delete
        else ### whether u_copy.save
          continue_with_goal_copy_and_removal = false

          u = "error creating copy of user_id " + user.id.to_s + " ... not deleting user"
          puts u
          logger.info("sgj:delete_old_account_data.rb:" + u )                

        end ### end if u_copy.save

      end ### end if !keep_user and continue_with_goal_copy_and_removal
    end ### end users.each do |user|

  end
  #######
  # END 1. delete any data for users who have not had activity for 1 year
  # 
  #######

  puts "end of script"

end