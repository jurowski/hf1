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

ActiveRecord::Schema.define(:version => 20130209103754) do

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
  end

  create_table "goals", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",                                                                  :null => false
    t.text     "summary"
    t.text     "why"
    t.date     "start"
    t.date     "stop"
    t.date     "established_on"
    t.string   "category"
    t.boolean  "publish",                                          :default => false
    t.boolean  "share",                                            :default => false
    t.string   "status",                                           :default => "start"
    t.text     "response_question"
    t.string   "response_options",                                 :default => "yes;no"
    t.time     "reminder_time"
    t.boolean  "higher_is_better",                                 :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "daysstraight"
    t.string   "laststatus"
    t.date     "laststatusdate"
    t.text     "pleasure"
    t.text     "pain"
    t.boolean  "pp_remind"
    t.date     "pp_remind_last_date"
    t.string   "gmtoffset",                          :limit => 10
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
    t.boolean  "more_reminders_enabled",                           :default => false
    t.integer  "more_reminders_start",                             :default => 8
    t.integer  "more_reminders_end",                               :default => 22
    t.integer  "more_reminders_every_n_hours",                     :default => 4
    t.integer  "more_reminders_last_sent",                         :default => 0
    t.date     "first_start_date"
    t.boolean  "allow_push",                                       :default => false
    t.string   "phrase1"
    t.string   "phrase2"
    t.string   "phrase3"
    t.string   "phrase4"
    t.string   "phrase5"
    t.date     "last_success_date"
    t.date     "next_push_on_or_after_date"
    t.integer  "pushes_allowed_per_day"
    t.integer  "pushes_remaining_on_next_push_date"
    t.integer  "team_summary_send_hour",                           :default => 12
    t.date     "team_summary_last_sent_date"
    t.boolean  "check_in_same_day",                                :default => true
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

  create_table "message_tags", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.boolean  "shared"
    t.integer  "organization_id"
    t.integer  "program_id"
    t.integer  "template_goal_id"
    t.string   "subject"
    t.text     "body"
    t.string   "source"
    t.boolean  "random_quote"
    t.boolean  "insert_in_checkin_emails"
    t.boolean  "insert_in_reminder_emails"
    t.boolean  "insert_in_webpage"
    t.boolean  "separate_email"
    t.boolean  "for_the_team"
    t.boolean  "for_an_individial"
    t.date     "for_this_date_only"
    t.date     "not_before_this_date"
    t.date     "not_after_this_date"
    t.integer  "trigger_id"
    t.integer  "allow_repeats_after_min_days"
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

  create_table "program_tags", :force => true do |t|
    t.integer  "program_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_templates", :force => true do |t|
    t.integer  "program_id"
    t.integer  "template_goal_id"
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
  end

  create_table "promotion1s", :force => true do |t|
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
    t.integer  "update_number_active_goals_i_follow",                                :default => 0
    t.integer  "active_goals_i_follow_tallied_hour",                                 :default => 0
    t.date     "last_activity_date"
    t.date     "active_goals_i_follow_tallied_date"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["supportpoints", "date_i_last_pushed_a_slacker", "slacker_id_that_i_last_pushed"], :name => "supportpoints"
  add_index "users", ["update_number_active_goals"], :name => "update_number_active_goals"

end
