# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140303110904) do

  create_table "achievemints", :force => true do |t|
    t.string   "name"
    t.string   "unit"
    t.string   "extra_param_1"
    t.string   "extra_param_2"
    t.string   "extra_param_3"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "affiliates", :force => true do |t|
    t.string   "email"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "affiliate_name"
    t.string   "coupon_code"
    t.integer  "coupon_discount"
    t.integer  "affiliate_earnings_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "last_payment_date"
  end

  create_table "betpayees", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "totaldonated",     :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.string   "image_path"
    t.string   "email"
    t.integer  "show_in_pulldown"
  end

  create_table "bets", :force => true do |t|
    t.integer  "credits"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "success_rate"
    t.integer  "donated_amount",        :limit => 10, :precision => 10, :scale => 0
    t.date     "donation_date"
    t.integer  "active_yn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "goal_id"
    t.integer  "betpayee_id"
    t.integer  "wager",                 :limit => 10, :precision => 10, :scale => 0
    t.string   "recipient_type"
    t.string   "recipient_email"
    t.integer  "floor"
    t.integer  "user_id"
    t.integer  "length_days"
    t.integer  "fire_type"
    t.integer  "paid_yn"
    t.string   "payment_url"
    t.date     "sent_bill_notice_date"
    t.string   "recipient_name"
    t.boolean  "error_on_notification"
  end

  create_table "checkpoint_achievemints", :force => true do |t|
    t.integer  "user_id"
    t.integer  "goal_id"
    t.integer  "template_goal_id"
    t.integer  "achievemint_id"
    t.integer  "checkpoint_id"
    t.string   "unit_value"
    t.string   "param_1_value"
    t.string   "param_2_value"
    t.string   "param_3_value"
    t.string   "transmission_status"
    t.integer  "points_worth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkpoint_removeds", :force => true do |t|
    t.integer  "checkpoint_id"
    t.string   "deleted_by"
    t.date     "deleted_on"
    t.date     "checkin_date"
    t.time     "checkin_time"
    t.string   "status"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.string   "syslognote"
  end

  create_table "checkpoints", :force => true do |t|
    t.date     "checkin_date"
    t.time     "checkin_time"
    t.string   "status",       :default => "email sent", :null => false
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.string   "syslognote"
  end

  add_index "checkpoints", ["goal_id"], :name => "index_checkpoints_on_goal_id"
  add_index "checkpoints", ["status"], :name => "status"

  create_table "cheers", :force => true do |t|
    t.string   "email"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "weekly_report",           :default => true
    t.date     "weekly_report_last_sent"
  end

  create_table "coach_emotion_images", :force => true do |t|
    t.integer  "coach_user_id"
    t.integer  "emotion_id"
    t.string   "image_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coach_motivation_types", :force => true do |t|
    t.integer  "coach_user_id"
    t.integer  "motivation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coach_templates", :force => true do |t|
    t.integer  "coach_user_id"
    t.integer  "template_goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coaches", :force => true do |t|
    t.integer  "user_id"
    t.string   "categories"
    t.integer  "client_count_limit"
    t.integer  "client_count_active"
    t.integer  "client_count_cumulative"
    t.integer  "is_willing_to_work"
    t.text     "blurb"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coachgoals", :force => true do |t|
    t.integer  "coach_id"
    t.integer  "goal_id"
    t.string   "goal_name"
    t.integer  "user_id"
    t.string   "user_email"
    t.string   "user_first_name"
    t.date     "coach_was_paid_out_on_date"
    t.integer  "coach_was_paid_out_amount",         :limit => 10, :precision => 10, :scale => 0
    t.integer  "amount_client_paid_total",          :limit => 10, :precision => 10, :scale => 0
    t.integer  "amount_client_paid_split_to_site",  :limit => 10, :precision => 10, :scale => 0
    t.integer  "amount_client_paid_split_to_coach", :limit => 10, :precision => 10, :scale => 0
    t.date     "week_1_email_due_date"
    t.date     "week_1_email_sent_date"
    t.date     "week_2_email_due_date"
    t.date     "week_2_email_sent_date"
    t.date     "week_3_email_due_date"
    t.date     "week_3_email_sent_date"
    t.date     "week_4_email_due_date"
    t.date     "week_4_email_sent_date"
    t.integer  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counter_images", :force => true do |t|
    t.integer  "counter_images_set_id"
    t.integer  "count"
    t.string   "image_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counter_images_sets", :force => true do |t|
    t.string   "counter_set_name"
    t.integer  "counter_limit_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cronjobs", :force => true do |t|
    t.string   "name"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.string   "metric_1_name"
    t.integer  "metric_1_value"
    t.string   "metric_2_name"
    t.integer  "metric_2_value"
    t.string   "metric_3_name"
    t.integer  "metric_3_value"
    t.boolean  "success"
    t.boolean  "failure"
    t.text     "notes"
    t.string   "cron_entry_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emotions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "encourage_items", :force => true do |t|
    t.boolean  "encourage_type_new_checkpoint_bool"
    t.boolean  "encourage_type_new_goal_bool"
    t.integer  "checkpoint_id"
    t.string   "checkpoint_status"
    t.date     "checkpoint_date"
    t.datetime "checkpoint_updated_at_datetime"
    t.integer  "goal_id"
    t.string   "goal_name"
    t.string   "goal_category"
    t.datetime "goal_created_at_datetime"
    t.boolean  "goal_publish"
    t.date     "goal_first_start_date"
    t.integer  "goal_daysstraight"
    t.integer  "goal_days_into_it"
    t.integer  "goal_success_rate_percentage"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "goal_momentum",                      :default => 0
    t.string   "category_image_name"
  end

  create_table "expiredcheckpoints", :force => true do |t|
    t.date     "checkin_date"
    t.time     "checkin_time"
    t.string   "status"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
  end

  create_table "failedcheckpoints", :force => true do |t|
    t.integer  "user_id"
    t.integer  "goal_id"
    t.integer  "checkpoint_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "frommessages", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "unread"
    t.integer  "rating"
    t.string   "category"
    t.string   "message_type"
  end

  create_table "goal_removeds", :force => true do |t|
    t.integer  "goal_id"
    t.string   "deleted_by"
    t.date     "deleted_on"
    t.integer  "user_id"
    t.string   "title",                                                                                       :null => false
    t.text     "summary"
    t.text     "why"
    t.date     "start"
    t.date     "stop"
    t.date     "established_on"
    t.string   "category"
    t.boolean  "publish",                                                               :default => false
    t.boolean  "share",                                                                 :default => false
    t.string   "status",                                                                :default => "start"
    t.text     "response_question"
    t.string   "response_options",                                                      :default => "yes;no"
    t.time     "reminder_time"
    t.boolean  "higher_is_better",                                                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "daysstraight"
    t.string   "laststatus"
    t.date     "laststatusdate"
    t.text     "pleasure"
    t.text     "pain"
    t.boolean  "pp_remind"
    t.date     "pp_remind_last_date"
    t.string   "gmtoffset",                                               :limit => 10
    t.integer  "serversendhour"
    t.integer  "usersendhour"
    t.boolean  "daym"
    t.boolean  "dayt"
    t.boolean  "dayw"
    t.boolean  "dayr"
    t.boolean  "dayf"
    t.boolean  "days"
    t.boolean  "dayn"
    t.integer  "pre_start_days_per_week"
    t.integer  "success_rate_percentage"
    t.integer  "days_into_it"
    t.integer  "goal_days_per_week"
    t.integer  "team_id"
    t.integer  "bet_id"
    t.integer  "is_coached"
    t.integer  "coachgoal_id"
    t.integer  "remind_me"
    t.integer  "reminder_send_hour"
    t.date     "reminder_last_sent_date"
    t.integer  "longestrun"
    t.string   "last_stats_badge"
    t.date     "last_stats_badge_date"
    t.string   "last_stats_badge_details"
    t.boolean  "more_reminders_enabled",                                                :default => false
    t.integer  "more_reminders_start",                                                  :default => 8
    t.integer  "more_reminders_end",                                                    :default => 22
    t.integer  "more_reminders_every_n_hours",                                          :default => 4
    t.integer  "more_reminders_last_sent",                                              :default => 0
    t.date     "first_start_date"
    t.boolean  "allow_push",                                                            :default => false
    t.string   "phrase1"
    t.string   "phrase2"
    t.string   "phrase3"
    t.string   "phrase4"
    t.string   "phrase5"
    t.date     "last_success_date"
    t.date     "next_push_on_or_after_date"
    t.integer  "pushes_allowed_per_day"
    t.integer  "pushes_remaining_on_next_push_date"
    t.integer  "team_summary_send_hour",                                                :default => 12
    t.date     "team_summary_last_sent_date"
    t.boolean  "check_in_same_day",                                                     :default => true
    t.boolean  "template_owner_is_a_template"
    t.boolean  "template_owner_advertise_me"
    t.integer  "template_user_parent_goal_id"
    t.integer  "achievemint_points_earned"
    t.integer  "level_points_earned"
    t.integer  "template_current_level_id"
    t.boolean  "template_let_user_choose_any_level_bool"
    t.boolean  "template_let_user_choose_lower_levels_bool"
    t.boolean  "template_on_level_success_go_to_next_goal_bool"
    t.boolean  "template_on_level_success_go_to_next_level_bool"
    t.boolean  "template_on_level_success_stop_goal_bool"
    t.boolean  "template_let_user_decide_when_to_move_to_next_goal_bool"
    t.integer  "template_next_template_goal_id"
    t.text     "template_description"
    t.string   "template_tagline"
    t.boolean  "template_next_template_goal_random_bool"
    t.integer  "goal_added_through_template_from_program_id"
    t.integer  "success_rate_during_past_7_days"
    t.integer  "success_rate_during_past_14_days"
    t.integer  "success_rate_during_past_21_days"
    t.integer  "success_rate_during_past_30_days"
    t.integer  "success_rate_during_past_60_days"
    t.integer  "success_rate_during_past_90_days"
    t.integer  "success_rate_during_past_180_days"
    t.integer  "success_rate_during_past_270_days"
    t.integer  "success_rate_during_past_365_days"
    t.boolean  "tracker"
    t.string   "tracker_question"
    t.string   "tracker_statement"
    t.string   "tracker_units"
    t.integer  "tracker_digits_after_decimal"
    t.integer  "tracker_standard_deviation_from_last_measurement"
    t.boolean  "tracker_type_starts_at_zero_daily",                                     :default => true
    t.boolean  "tracker_target_higher_value_is_better",                                 :default => true
    t.boolean  "tracker_set_checkpoint_to_yes_if_any_answer",                           :default => true
    t.boolean  "tracker_set_checkpoint_to_yes_only_if_answer_acceptable",               :default => true
    t.integer  "tracker_target_threshold_bad1"
    t.integer  "tracker_target_threshold_bad2"
    t.integer  "tracker_target_threshold_bad3"
    t.integer  "tracker_target_threshold_good1"
    t.integer  "tracker_target_threshold_good2"
    t.integer  "tracker_target_threshold_good3"
    t.integer  "tracker_measurement_worst_yet"
    t.integer  "tracker_measurement_best_yet"
    t.date     "tracker_measurement_last_taken_on_date"
    t.integer  "tracker_measurement_last_taken_on_hour"
    t.integer  "tracker_measurement_last_taken_value"
    t.datetime "tracker_measurement_last_taken_timestamp"
    t.integer  "tracker_prompt_after_n_days_without_entry"
    t.boolean  "tracker_prompt_for_an_initial_value"
    t.boolean  "tracker_track_difference_between_initial_and_latest"
    t.integer  "tracker_difference_between_initial_and_latest"
  end

  create_table "goals", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",                                                                                                                      :null => false
    t.text     "summary"
    t.text     "why"
    t.date     "start"
    t.date     "stop"
    t.date     "established_on"
    t.string   "category"
    t.boolean  "publish",                                                                                              :default => false
    t.boolean  "share",                                                                                                :default => false
    t.string   "status",                                                                                               :default => "start"
    t.text     "response_question"
    t.string   "response_options",                                                                                     :default => "yes;no"
    t.time     "reminder_time"
    t.boolean  "higher_is_better",                                                                                     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "daysstraight"
    t.string   "laststatus"
    t.date     "laststatusdate"
    t.text     "pleasure"
    t.text     "pain"
    t.boolean  "pp_remind"
    t.date     "pp_remind_last_date"
    t.string   "gmtoffset",                                               :limit => 10
    t.integer  "serversendhour"
    t.integer  "usersendhour"
    t.boolean  "daym"
    t.boolean  "dayt"
    t.boolean  "dayw"
    t.boolean  "dayr"
    t.boolean  "dayf"
    t.boolean  "days"
    t.boolean  "dayn"
    t.integer  "pre_start_days_per_week"
    t.integer  "success_rate_percentage"
    t.integer  "days_into_it"
    t.integer  "goal_days_per_week"
    t.integer  "team_id"
    t.integer  "bet_id"
    t.integer  "is_coached"
    t.integer  "coachgoal_id"
    t.integer  "remind_me"
    t.integer  "reminder_send_hour"
    t.date     "reminder_last_sent_date"
    t.integer  "longestrun"
    t.string   "last_stats_badge"
    t.date     "last_stats_badge_date"
    t.string   "last_stats_badge_details"
    t.boolean  "more_reminders_enabled",                                                                               :default => false
    t.integer  "more_reminders_start",                                                                                 :default => 8
    t.integer  "more_reminders_end",                                                                                   :default => 22
    t.integer  "more_reminders_every_n_hours",                                                                         :default => 4
    t.integer  "more_reminders_last_sent",                                                                             :default => 0
    t.date     "first_start_date"
    t.boolean  "allow_push",                                                                                           :default => false
    t.string   "phrase1"
    t.string   "phrase2"
    t.string   "phrase3"
    t.string   "phrase4"
    t.string   "phrase5"
    t.date     "last_success_date"
    t.date     "next_push_on_or_after_date"
    t.integer  "pushes_allowed_per_day"
    t.integer  "pushes_remaining_on_next_push_date"
    t.integer  "team_summary_send_hour",                                                                               :default => 12
    t.date     "team_summary_last_sent_date"
    t.boolean  "check_in_same_day",                                                                                    :default => true
    t.boolean  "template_owner_is_a_template"
    t.boolean  "template_owner_advertise_me"
    t.integer  "template_user_parent_goal_id"
    t.integer  "achievemint_points_earned"
    t.integer  "level_points_earned"
    t.integer  "template_current_level_id"
    t.boolean  "template_let_user_choose_any_level_bool"
    t.boolean  "template_let_user_choose_lower_levels_bool"
    t.boolean  "template_on_level_success_go_to_next_goal_bool"
    t.boolean  "template_on_level_success_go_to_next_level_bool"
    t.boolean  "template_on_level_success_stop_goal_bool"
    t.boolean  "template_let_user_decide_when_to_move_to_next_goal_bool"
    t.integer  "template_next_template_goal_id"
    t.text     "template_description"
    t.string   "template_tagline"
    t.boolean  "template_next_template_goal_random_bool"
    t.integer  "goal_added_through_template_from_program_id"
    t.integer  "success_rate_during_past_7_days"
    t.integer  "success_rate_during_past_14_days"
    t.integer  "success_rate_during_past_21_days"
    t.integer  "success_rate_during_past_30_days"
    t.integer  "success_rate_during_past_60_days"
    t.integer  "success_rate_during_past_90_days"
    t.integer  "success_rate_during_past_180_days"
    t.integer  "success_rate_during_past_270_days"
    t.integer  "success_rate_during_past_365_days"
    t.boolean  "tracker"
    t.string   "tracker_question"
    t.string   "tracker_statement"
    t.string   "tracker_units"
    t.integer  "tracker_digits_after_decimal"
    t.integer  "tracker_standard_deviation_from_last_measurement"
    t.boolean  "tracker_type_starts_at_zero_daily",                                                                    :default => true
    t.boolean  "tracker_target_higher_value_is_better",                                                                :default => true
    t.boolean  "tracker_set_checkpoint_to_yes_if_any_answer",                                                          :default => true
    t.boolean  "tracker_set_checkpoint_to_yes_only_if_answer_acceptable",                                              :default => true
    t.integer  "tracker_target_threshold_bad1",                           :limit => 10, :precision => 10, :scale => 0
    t.integer  "tracker_target_threshold_bad2",                           :limit => 10, :precision => 10, :scale => 0
    t.integer  "tracker_target_threshold_bad3",                           :limit => 10, :precision => 10, :scale => 0
    t.integer  "tracker_target_threshold_good1",                          :limit => 10, :precision => 10, :scale => 0
    t.integer  "tracker_target_threshold_good2",                          :limit => 10, :precision => 10, :scale => 0
    t.integer  "tracker_target_threshold_good3",                          :limit => 10, :precision => 10, :scale => 0
    t.integer  "tracker_measurement_worst_yet",                           :limit => 10, :precision => 10, :scale => 0
    t.integer  "tracker_measurement_best_yet",                            :limit => 10, :precision => 10, :scale => 0
    t.date     "tracker_measurement_last_taken_on_date"
    t.integer  "tracker_measurement_last_taken_on_hour"
    t.integer  "tracker_measurement_last_taken_value",                    :limit => 10, :precision => 10, :scale => 0
    t.datetime "tracker_measurement_last_taken_timestamp"
    t.integer  "tracker_prompt_after_n_days_without_entry"
    t.boolean  "tracker_prompt_for_an_initial_value"
    t.boolean  "tracker_track_difference_between_initial_and_latest"
    t.integer  "tracker_difference_between_initial_and_latest",           :limit => 10, :precision => 10, :scale => 0
  end

  add_index "goals", ["allow_push", "last_success_date", "next_push_on_or_after_date", "pushes_remaining_on_next_push_date"], :name => "allow_push"
  add_index "goals", ["user_id"], :name => "index_goals_on_user_id"

  create_table "goaltags", :force => true do |t|
    t.integer  "goaltemplate_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "goal_id"
  end

  create_table "goaltemplates", :force => true do |t|
    t.string   "title"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", :force => true do |t|
    t.integer  "from_user_id"
    t.string   "to_name"
    t.string   "to_email"
    t.integer  "to_user_id"
    t.integer  "purpose_join_team_id"
    t.integer  "purpose_follow_goal_id"
    t.integer  "purpose_friend_user_id"
    t.date     "accepted_on"
    t.date     "declined_loudly_on"
    t.date     "declined_silently_on"
    t.date     "first_sent_on"
    t.date     "last_resent_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "invitation_body"
    t.string   "invitation_subject"
    t.integer  "purpose_join_program_id"
  end

  create_table "level_goals", :force => true do |t|
    t.integer  "level_id"
    t.integer  "goal_id"
    t.string   "prize_message_status"
    t.integer  "points"
    t.text     "notes"
    t.date     "date_achieved"
    t.integer  "success_rate"
    t.integer  "success_count"
    t.integer  "days_in"
    t.string   "name"
    t.text     "description"
    t.string   "prize_image_name"
    t.integer  "prize_image_height"
    t.string   "prize_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "levels", :force => true do |t|
    t.boolean  "shared"
    t.integer  "organization_id"
    t.integer  "program_id"
    t.integer  "template_goal_id"
    t.integer  "next_level_id"
    t.boolean  "this_is_the_first_level"
    t.integer  "points"
    t.string   "name"
    t.text     "description"
    t.string   "tempt_image_name"
    t.integer  "tempt_image_height"
    t.string   "prize_image_name"
    t.integer  "prize_image_height"
    t.string   "prize_url"
    t.integer  "prize_message_id"
    t.integer  "trigger_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_emotions", :force => true do |t|
    t.integer  "message_id"
    t.integer  "emotion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_goals", :force => true do |t|
    t.integer  "message_id"
    t.integer  "goal_id"
    t.integer  "trigger_id"
    t.date     "sent_date"
    t.datetime "sent_datetime"
    t.string   "sent_status"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_motivations", :force => true do |t|
    t.integer  "message_id"
    t.integer  "motivation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_tags", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.text     "refcode"
    t.boolean  "shared"
    t.integer  "organization_id"
    t.integer  "program_id"
    t.integer  "template_goal_id"
    t.string   "subject"
    t.text     "body"
    t.text     "language"
    t.string   "source"
    t.boolean  "random_quote"
    t.boolean  "insert_in_checkin_emails"
    t.boolean  "insert_in_reminder_emails"
    t.boolean  "insert_in_webpage"
    t.boolean  "separate_email"
    t.boolean  "for_the_team"
    t.boolean  "for_an_individial"
    t.boolean  "for_the_system"
    t.date     "for_this_date_only"
    t.date     "not_before_this_date"
    t.date     "not_after_this_date"
    t.integer  "trigger_id"
    t.integer  "allow_repeats_after_min_days"
    t.boolean  "this_is_one_of_the_actual_checkin_questions_bool"
    t.boolean  "this_is_a_random_congrats_message_bool"
    t.boolean  "this_is_a_random_sorry_message_bool"
    t.boolean  "this_is_a_random_push_bool"
    t.boolean  "allow_from_coach_bool"
    t.boolean  "allow_from_team_member_bool"
    t.boolean  "allow_from_follower_bool"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "motivation_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_users", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.boolean  "admin"
    t.boolean  "coach"
    t.boolean  "editor"
    t.boolean  "publisher"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.integer  "managed_by_user_id"
    t.string   "name"
    t.text     "about"
    t.string   "url"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "image_logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_enrollments", :force => true do |t|
    t.integer  "program_id"
    t.integer  "user_id"
    t.boolean  "active"
    t.boolean  "ongoing"
    t.integer  "program_session_id"
    t.date     "personal_start_date"
    t.date     "personal_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_motivation_types", :force => true do |t|
    t.integer  "program_id"
    t.integer  "motivation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_sessions", :force => true do |t|
    t.integer  "program_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_tags", :force => true do |t|
    t.integer  "program_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_templates", :force => true do |t|
    t.integer  "program_id"
    t.integer  "template_goal_id"
    t.integer  "listing_position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "managed_by_user_id"
    t.string   "image_logo"
    t.string   "name"
    t.text     "about"
    t.text     "joined_count"
    t.text     "current_count"
    t.integer  "rating_stars"
    t.integer  "rating_votes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "catch_phrase"
    t.string   "stale_after_days_of_silence_count"
    t.string   "difficulty_rating"
    t.string   "version_number"
    t.string   "status"
    t.boolean  "actions_list_dropdown"
    t.boolean  "duration_ongoing",                  :default => true
    t.boolean  "duration_is_in_months_bool",        :default => false
    t.boolean  "duration_is_in_weeks_bool",         :default => false
    t.boolean  "duration_is_in_days_bool",          :default => false
    t.integer  "duration_qty",                      :default => 0
    t.boolean  "duration_start_is_fixed",           :default => false
    t.boolean  "structured",                        :default => false
    t.boolean  "invite_only"
    t.text     "invitation_body"
    t.string   "invitation_subject"
    t.integer  "count_of_enrolled_users"
    t.boolean  "requires_external_membership"
    t.boolean  "link_image_to_external_site"
    t.string   "external_membership_url"
    t.string   "external_membership_text"
  end

  create_table "promotion1s", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quants", :force => true do |t|
    t.integer  "user_id"
    t.integer  "goal_id"
    t.integer  "measurement",                 :limit => 10, :precision => 10, :scale => 0
    t.datetime "measurement_taken_timestamp"
    t.date     "measurement_date"
    t.integer  "measurement_hour"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quotes", :force => true do |t|
    t.text     "thought"
    t.string   "author"
    t.date     "last_used"
    t.boolean  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sponsor"
    t.string   "category"
    t.string   "source"
    t.string   "subject"
  end

  create_table "quotetags", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "quote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "stats", :force => true do |t|
    t.date     "recorddate"
    t.integer  "recordhour"
    t.integer  "usercount"
    t.integer  "goalcount"
    t.integer  "goalactivecount"
    t.integer  "goalsnewcreated"
    t.integer  "usersnewcreated"
    t.integer  "checkpointemailssent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "totalheckpointemailfailure"
    t.integer  "activeusercount"
    t.integer  "activegoalcount"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.boolean  "shared"
    t.integer  "organization_id"
    t.integer  "program_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_invites", :force => true do |t|
    t.integer  "team_id"
    t.string   "email_original"
    t.integer  "user_id"
    t.integer  "goal_id"
    t.date     "first_sent_date"
    t.date     "remind_until_date"
    t.integer  "remind_every_n_days"
    t.date     "last_reminded_date"
    t.date     "declined_date"
    t.date     "ignored_date"
    t.date     "accepted_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teamgoals", :force => true do |t|
    t.integer  "team_id"
    t.integer  "goal_id"
    t.integer  "rating"
    t.integer  "qty_kickoff_votes"
    t.integer  "active"
    t.integer  "suspend"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank"
    t.integer  "success_rate"
    t.integer  "days_in_a_row"
    t.integer  "met_goal_last_week"
    t.date     "last_checkin_date"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "category_name"
    t.integer  "qty_max"
    t.integer  "qty_current"
    t.integer  "avg_success_rate"
    t.integer  "avg_days_in_a_row"
    t.integer  "avg_met_goal_last_week"
    t.integer  "qty_checked_in_yesterday"
    t.integer  "qty_checked_in_last_2_days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "has_opening"
    t.integer  "goal_template_parent_id"
    t.boolean  "custom"
    t.integer  "owner_user_id"
    t.integer  "success_rate_during_past_7_days"
    t.integer  "success_rate_during_past_14_days"
    t.integer  "success_rate_during_past_21_days"
    t.integer  "success_rate_during_past_30_days"
    t.integer  "success_rate_during_past_60_days"
    t.integer  "success_rate_during_past_90_days"
    t.integer  "success_rate_during_past_180_days"
    t.integer  "success_rate_during_past_270_days"
    t.integer  "success_rate_during_past_365_days"
    t.boolean  "invite_only"
    t.text     "invitation_body"
    t.string   "invitation_subject"
  end

  create_table "template_achievemints", :force => true do |t|
    t.integer  "template_goal_id"
    t.integer  "achievemint_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_tags", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "template_goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tomessages", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "unread"
    t.integer  "rating"
    t.string   "category"
    t.string   "message_type"
  end

  create_table "triggers", :force => true do |t|
    t.boolean  "shared"
    t.integer  "organization_id"
    t.integer  "program_id"
    t.integer  "template_goal_id"
    t.boolean  "trigger_for_silence_instead_of_reports"
    t.boolean  "trigger_for_failure_instead_of_success"
    t.boolean  "trigger_once_days_straight_success_or_failure"
    t.boolean  "trigger_once_lagging_rate_success_or_failure"
    t.boolean  "trigger_once_total_days_of_success_or_failure"
    t.boolean  "trigger_once_min_total_days_elapsed"
    t.integer  "min_total_days_elapsed"
    t.integer  "min_lag_days"
    t.integer  "min_success_or_failure_days"
    t.integer  "min_success_or_failure_rate"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "trigger_on_momentum_rate"
    t.integer  "max_success_or_failure_rate"
  end

  create_table "user_friends", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_motivation_types", :force => true do |t|
    t.integer  "user_id"
    t.integer  "motivation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_removeds", :force => true do |t|
    t.integer  "user_id"
    t.string   "deleted_by"
    t.date     "deleted_on"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                                                             :default => "",    :null => false
    t.string   "string",                                                            :default => "",    :null => false
    t.string   "crypted_password",                                                                     :null => false
    t.string   "password_salt",                                                                        :null => false
    t.string   "persistence_token",                                                                    :null => false
    t.string   "single_access_token",                                                                  :null => false
    t.string   "perishable_token",                                                  :default => "",    :null => false
    t.integer  "login_count",                                                       :default => 0,     :null => false
    t.integer  "failed_login_count",                                                :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
    t.integer  "update_number_active_goals"
    t.string   "gender"
    t.integer  "yob"
    t.string   "sponsor"
    t.date     "last_donation_date"
    t.integer  "donated_so_far"
    t.date     "kill_ads_until"
    t.integer  "unlimited_goals"
    t.integer  "combine_daily_emails"
    t.decimal  "payments",                            :precision => 8, :scale => 2
    t.integer  "is_admin"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "cost_per_period"
    t.string   "period"
    t.string   "subscriptionid"
    t.text     "subscriptionmessage"
    t.string   "plan"
    t.date     "premium_start_date"
    t.date     "premium_stop_date"
    t.integer  "is_a_coach"
    t.integer  "coach_id"
    t.date     "sent_expire_warning_on"
    t.date     "sent_expire_notice_on"
    t.integer  "opt_in_random_fire"
    t.integer  "affiliate_id"
    t.integer  "is_affiliate"
    t.integer  "active_goals_tallied_hour"
    t.string   "password_temp"
    t.string   "goal_temp"
    t.string   "referer"
    t.integer  "supportpoints"
    t.text     "supportpoints_log"
    t.date     "promo_comeback_last_sent"
    t.string   "promo_comeback_token"
    t.boolean  "undeliverable",                                                     :default => false
    t.date     "undeliverable_date_checked"
    t.date     "last_activity_date"
    t.boolean  "show_gravatar",                                                     :default => true
    t.integer  "impact_points"
    t.date     "date_of_signup"
    t.date     "got_free_membership"
    t.boolean  "feed_filter_show_my_categories_only"
    t.boolean  "feed_filter_hide_pmo"
    t.string   "country"
    t.string   "country_code"
    t.string   "state_code"
    t.integer  "fb_id"
    t.string   "fb_email"
    t.string   "fb_username"
    t.string   "fb_first_name"
    t.string   "fb_last_name"
    t.string   "fb_gender"
    t.string   "fb_timezone"
    t.integer  "google_user_id"
    t.string   "google_email"
    t.string   "handle"
    t.boolean  "hide_feed"
    t.boolean  "premium_only_complete_privacy"
    t.boolean  "premium_only_default_private_goal"
    t.date     "deletion_warning"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                                                              :default => "",    :null => false
    t.string   "string",                                                             :default => "",    :null => false
    t.string   "crypted_password",                                                                      :null => false
    t.string   "password_salt",                                                                         :null => false
    t.string   "persistence_token",                                                                     :null => false
    t.string   "single_access_token",                                                                   :null => false
    t.string   "perishable_token",                                                   :default => "",    :null => false
    t.integer  "login_count",                                                        :default => 0,     :null => false
    t.integer  "failed_login_count",                                                 :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
    t.integer  "update_number_active_goals"
    t.string   "gender"
    t.integer  "yob"
    t.string   "sponsor"
    t.integer  "unsubscribed_from_promo_emails"
    t.string   "promo_1_token"
    t.integer  "promo_1_sent"
    t.date     "last_donation_date"
    t.date     "last_donation_plea_date"
    t.integer  "donated_so_far"
    t.integer  "promo_1_responded"
    t.date     "kill_ads_until"
    t.integer  "unlimited_goals"
    t.integer  "hide_donation_plea"
    t.integer  "combine_daily_emails"
    t.decimal  "payments",                             :precision => 8, :scale => 2
    t.date     "coach_follow_next"
    t.date     "coach_follow_last"
    t.integer  "coach_follow_yn"
    t.integer  "is_admin"
    t.string   "cc_first_name"
    t.string   "cc_last_name"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "cc_number"
    t.string   "cc_code"
    t.string   "cc_expire_month"
    t.string   "cc_expire_year"
    t.date     "cc_expire_date"
    t.string   "cost_per_period"
    t.string   "period"
    t.string   "subscriptionid"
    t.text     "subscriptionmessage"
    t.string   "plan"
    t.date     "premium_start_date"
    t.date     "premium_stop_date"
    t.integer  "is_a_coach"
    t.integer  "coach_id"
    t.date     "sent_expire_warning_on"
    t.date     "sent_expire_notice_on"
    t.integer  "opt_in_random_fire"
    t.integer  "affiliate_id"
    t.integer  "is_affiliate"
    t.integer  "active_goals_tallied_hour"
    t.string   "password_temp"
    t.string   "goal_temp"
    t.string   "referer"
    t.integer  "supportpoints"
    t.text     "supportpoints_log"
    t.date     "date_last_prompted_to_push_a_slacker"
    t.date     "date_i_last_pushed_a_slacker"
    t.integer  "slacker_id_that_i_last_pushed"
    t.date     "promo_comeback_last_sent"
    t.string   "promo_comeback_token"
    t.boolean  "undeliverable",                                                      :default => false
    t.date     "undeliverable_date_checked"
    t.boolean  "confirmed_address",                                                  :default => false
    t.string   "confirmed_address_token"
    t.boolean  "asked_for_testimonial",                                              :default => false
    t.date     "active_goals_i_follow_tallied_date"
    t.integer  "update_number_active_goals_i_follow",                                :default => 0
    t.integer  "active_goals_i_follow_tallied_hour",                                 :default => 0
    t.integer  "coach_organization_id"
    t.string   "coach_first_name"
    t.string   "coach_last_name"
    t.string   "coach_gender"
    t.string   "coach_tagline"
    t.text     "coach_description"
    t.string   "coach_image_standard"
    t.string   "coach_contact_email"
    t.string   "coach_contact_phone"
    t.date     "last_activity_date"
    t.boolean  "show_gravatar",                                                      :default => true
    t.integer  "impact_points"
    t.date     "date_of_signup"
    t.date     "got_free_membership"
    t.boolean  "feed_filter_show_my_categories_only"
    t.boolean  "feed_filter_hide_pmo"
    t.string   "country"
    t.string   "country_code"
    t.string   "state_code"
    t.integer  "fb_id"
    t.string   "fb_email"
    t.string   "fb_username"
    t.string   "fb_first_name"
    t.string   "fb_last_name"
    t.string   "fb_gender"
    t.string   "fb_timezone"
    t.integer  "google_user_id"
    t.string   "google_email"
    t.string   "handle"
    t.boolean  "hide_feed"
    t.boolean  "premium_only_complete_privacy"
    t.boolean  "premium_only_default_private_goal"
    t.date     "deletion_warning"
    t.date     "asked_for_job_lead_on"
    t.date     "asked_for_job_lead_on_failure"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["supportpoints", "date_i_last_pushed_a_slacker", "slacker_id_that_i_last_pushed"], :name => "supportpoints"
  add_index "users", ["update_number_active_goals"], :name => "update_number_active_goals"

  create_table "weight_loss_by_states", :force => true do |t|
    t.string   "state"
    t.string   "state_code"
    t.integer  "demog_population"
    t.integer  "demog_percent_adults"
    t.integer  "demog_number_adults"
    t.integer  "demog_percent_obesity_rate"
    t.integer  "demog_number_obese_adults"
    t.integer  "demog_percent_of_total_obese_adults_in_challenge"
    t.integer  "challenge_weighted_goal"
    t.integer  "challenge_qty_hold"
    t.integer  "challenge_qty_active"
    t.integer  "challenge_lbs_starting_weight_hold"
    t.integer  "challenge_lbs_starting_weight_active"
    t.integer  "challenge_lbs_last_weight_hold"
    t.integer  "challenge_lbs_last_weight_active"
    t.integer  "challenge_lbs_lost_hold"
    t.integer  "challenge_lbs_lost_active"
    t.integer  "challenge_lbs_lost_total"
    t.integer  "challenge_percent_of_goal_met"
    t.integer  "challenge_number_rank"
    t.date     "challenge_last_updated_date"
    t.string   "js_upcolor"
    t.string   "js_overcolor"
    t.string   "js_downcolor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.integer  "map_code"
  end

end
