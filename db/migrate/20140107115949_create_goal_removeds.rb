class CreateGoalRemoveds < ActiveRecord::Migration

  def self.up
    create_table :goal_removeds do |t|
      t.integer :goal_id

      t.string :deleted_by
      t.date :deleted_on

      	### copied from goals table 20140107 (minus a few fields that we don't care about)
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


      t.timestamps
    end
  end

  def self.down
    drop_table :goal_removeds
  end
end
