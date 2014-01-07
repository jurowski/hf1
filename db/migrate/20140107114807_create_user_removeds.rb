class CreateUserRemoveds < ActiveRecord::Migration

  def self.up
    create_table :user_removeds do |t|
      t.integer :user_id
      t.string :deleted_by
      t.date :deleted_on

      	### copied from users table 20140107 (minus a few fields that we don't care about)
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
		t.date     "last_donation_date"
		t.integer  "donated_so_far"
		t.date     "kill_ads_until"
		t.integer  "unlimited_goals"
		t.integer  "combine_daily_emails"
		t.decimal  "payments",                             :precision => 8, :scale => 2
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
		t.boolean  "undeliverable",                                                      :default => false
		t.date     "undeliverable_date_checked"
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





      t.timestamps
    end
  end

  def self.down
    drop_table :user_removeds
  end
end
