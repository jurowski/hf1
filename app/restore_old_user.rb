require 'active_record'
require 'logger'
require 'date'

class RestoreOldUser < ActiveRecord::Base


  ### RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/restore_old_user.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/restore_old_user.rb


  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/restore_old_user.rb

  # This script:
  # moves people from the users_pre_purge_201306 table back into the users table

  ### Whether to run the above steps
  run_1 = true

  


  #######
  # START 1. copy the user back in
  #######
  if run_1

#### !!!! use the now-indexed "copied_back" to record whether they have been copied over


    sql = "SELECT * FROM users_pre_purge_201306 where copied_back = '0' LIMIT 250"
    old_users_array = ActiveRecord::Base.connection.execute(sql)

    old_users_array.each do |user|


      # mysql> show columns from users_pre_purge_201306;
      # +--------------------------------------+--------------+------+-----+---------+----------------+
      # | Field                                | Type         | Null | Key | Default | Extra          |
      # +--------------------------------------+--------------+------+-----+---------+----------------+
      # |0 id                                   | int(11)      | NO   | PRI | NULL    | auto_increment |
      # |1 first_name                           | varchar(255) | YES  |     | NULL    |                |
      # |2 last_name                            | varchar(255) | YES  |     | NULL    |                |
      # |3 email                                | varchar(255) | NO   | MUL |         |                |
      # |4 string                               | varchar(255) | NO   |     |         |                |
      # |5 crypted_password                     | varchar(255) | NO   |     | NULL    |                |
      # |6 password_salt                        | varchar(255) | NO   |     | NULL    |                |
      # |7 persistence_token                    | varchar(255) | NO   |     | NULL    |                |
      # |8 single_access_token                  | varchar(255) | NO   |     | NULL    |                |
      # |9 perishable_token                     | varchar(255) | NO   | MUL |         |                |
      # |10 login_count                          | int(11)      | NO   |     | 0       |                |
      # |11 failed_login_count                   | int(11)      | NO   |     | 0       |                |
      # |12 last_request_at                      | datetime     | YES  |     | NULL    |                |
      # |13 current_login_at                     | datetime     | YES  |     | NULL    |                |
      # |14 last_login_at                        | datetime     | YES  |     | NULL    |                |
      # |15 current_login_ip                     | varchar(255) | YES  |     | NULL    |                |
      # |16 last_login_ip                        | varchar(255) | YES  |     | NULL    |                |
      # |17 created_at                           | datetime     | YES  |     | NULL    |                |
      # |18 updated_at                           | datetime     | YES  |     | NULL    |                |
      # |19 time_zone                            | varchar(255) | YES  | MUL | NULL    |                |
      # |20 update_number_active_goals           | int(11)      | YES  | MUL | NULL    |                |
      # |21 gender                               | varchar(255) | YES  |     | NULL    |                |
      # |22 yob                                  | int(11)      | YES  |     | NULL    |                |
      # |23 sponsor                              | varchar(255) | YES  | MUL | NULL    |                |
      # |24 unsubscribed_from_promo_emails       | int(11)      | YES  |     | NULL    |                |
      # |25 promo_1_token                        | varchar(255) | YES  |     | NULL    |                |
      # |26 promo_1_sent                         | int(11)      | YES  |     | NULL    |                |
      # |27 last_donation_date                   | date         | YES  |     | NULL    |                |
      # |28 last_donation_plea_date              | date         | YES  |     | NULL    |                |
      # |29 donated_so_far                       | int(11)      | YES  |     | NULL    |                |
      # |30 promo_1_responded                    | int(11)      | YES  |     | NULL    |                |
      # |31 kill_ads_until                       | date         | YES  | MUL | NULL    |                |
      # |32 unlimited_goals                      | int(11)      | YES  |     | NULL    |                |
      # |33 hide_donation_plea                   | int(11)      | YES  |     | NULL    |                |
      # |34 combine_daily_emails                 | int(11)      | YES  |     | NULL    |                |
      # |35 payments                             | decimal(8,2) | YES  |     | NULL    |                |
      # |36 coach_follow_next                    | date         | YES  |     | NULL    |                |
      # |37 coach_follow_last                    | date         | YES  |     | NULL    |                |
      # |38 coach_follow_yn                      | int(11)      | YES  |     | NULL    |                |
      # |39 is_admin                             | int(11)      | YES  |     | NULL    |                |
      # |40 cc_first_name                        | varchar(255) | YES  |     | NULL    |                |
      # |41 cc_last_name                         | varchar(255) | YES  |     | NULL    |                |
      # |42 street1                              | varchar(255) | YES  |     | NULL    |                |
      # |43 street2                              | varchar(255) | YES  |     | NULL    |                |
      # |44 city                                 | varchar(255) | YES  |     | NULL    |                |
      # |45 state                                | varchar(255) | YES  |     | NULL    |                |
      # |46 zip                                  | varchar(255) | YES  |     | NULL    |                |
      # |47 phone                                | varchar(255) | YES  |     | NULL    |                |
      # |48 cc_number                            | varchar(255) | YES  |     | NULL    |                |
      # |49 cc_code                              | varchar(255) | YES  |     | NULL    |                |
      # |50 cc_expire_month                      | varchar(255) | YES  |     | NULL    |                |
      # |51 cc_expire_year                       | varchar(255) | YES  |     | NULL    |                |
      # |52 cc_expire_date                       | date         | YES  |     | NULL    |                |
      # |53 cost_per_period                      | varchar(255) | YES  |     | NULL    |                |
      # |54 period                               | varchar(255) | YES  |     | NULL    |                |
      # |55 subscriptionid                       | varchar(255) | YES  |     | NULL    |                |
      # |56 subscriptionmessage                  | text         | YES  |     | NULL    |                |
      # |57 plan                                 | varchar(255) | YES  |     | NULL    |                |
      # |58 premium_start_date                   | date         | YES  |     | NULL    |                |
      # |59 premium_stop_date                    | date         | YES  |     | NULL    |                |
      # |60 is_a_coach                           | int(11)      | YES  |     | NULL    |                |
      # |61 coach_id                             | int(11)      | YES  |     | NULL    |                |
      # |62 sent_expire_warning_on               | date         | YES  |     | NULL    |                |
      # |63 sent_expire_notice_on                | date         | YES  |     | NULL    |                |
      # |64 opt_in_random_fire                   | int(11)      | YES  |     | NULL    |                |
      # |65 affiliate_id                         | int(11)      | YES  |     | NULL    |                |
      # |66 is_affiliate                         | int(11)      | YES  |     | NULL    |                |
      # |67 active_goals_tallied_hour            | int(11)      | YES  |     | NULL    |                |
      # |68 password_temp                        | varchar(255) | YES  |     | NULL    |                |
      # |69 goal_temp                            | varchar(255) | YES  |     | NULL    |                |
      # |70 referer                              | varchar(255) | YES  |     | NULL    |                |
      # |71 supportpoints                        | int(11)      | YES  | MUL | NULL    |                |
      # |72 supportpoints_log                    | text         | YES  |     | NULL    |                |
      # |73 date_last_prompted_to_push_a_slacker | date         | YES  |     | NULL    |                |
      # |74 date_i_last_pushed_a_slacker         | date         | YES  |     | NULL    |                |
      # |75 slacker_id_that_i_last_pushed        | int(11)      | YES  |     | NULL    |                |
      # |76 promo_comeback_last_sent             | date         | YES  |     | NULL    |                |
      # |77 promo_comeback_token                 | varchar(255) | YES  |     | NULL    |                |
      # |78 undeliverable                        | tinyint(1)   | YES  |     | 0       |                |
      # |79 undeliverable_date_checked           | date         | YES  |     | NULL    |                |
      # |80 confirmed_address                    | tinyint(1)   | YES  |     | 0       |                |
      # |81 confirmed_address_token              | varchar(255) | YES  |     | NULL    |                |
      # |82 asked_for_testimonial                | tinyint(1)   | YES  |     | 0       |                |
      # |83 update_number_active_goals_i_follow  | int(11)      | YES  |     | 0       |                |
      # |84 active_goals_i_follow_tallied_hour   | int(11)      | YES  |     | 0       |                |
      # |85 last_activity_date                   | date         | YES  | MUL | NULL    |                |
      # |86 active_goals_i_follow_tallied_date   | date         | YES  |     | NULL    |                |
      # |87 coach_organization_id                | int(11)      | YES  |     | NULL    |                |
      # |88 coach_first_name                     | varchar(255) | YES  |     | NULL    |                |
      # |89 coach_last_name                      | varchar(255) | YES  |     | NULL    |                |
      # |90 coach_gender                         | varchar(255) | YES  |     | NULL    |                |
      # |91 coach_tagline                        | varchar(255) | YES  |     | NULL    |                |
      # |92 coach_description                    | text         | YES  |     | NULL    |                |
      # |93 coach_image_standard                 | varchar(255) | YES  |     | NULL    |                |
      # |94 coach_contact_email                  | varchar(255) | YES  |     | NULL    |                |
      # |95 coach_contact_phone                  | varchar(255) | YES  |     | NULL    |                |
      # |96 show_gravatar                        | tinyint(1)   | YES  |     | 1       |                |
      # |97 copied_back                          | int(11)      | YES  |     | NULL    |                |
      # +--------------------------------------+--------------+------+-----+---------+----------------+
      # 98 rows in set (0.01 sec)

      puts "email: " + user[3]

      u_copy = User.new

      # u_copy.first_name = "hi"
      # u_copy.last_name = ""
      # u_copy.email = "lkjkewre@sfsfd.com"
      # u_copy.email_confirmation = u_copy.email
      # u_copy.password = "xxxx"
      # u_copy.password_confirmation = u_copy.password

      # u_copy.sponsor = "habitforge"
      # u_copy.time_zone = "Central Time (US & Canada)"
      # u_copy.update_number_active_goals = 0

      # u_copy.save!

      u_copy.first_name = user[1]
      u_copy.last_name = user[2]
      u_copy.email = user[3]
      u_copy.email_confirmation = user[3]
      
      u_copy.string = user[4]
      # u_copy.crypted_password = user[5]
      # u_copy.password_salt = user[6]

        random_pw_number = rand(1000) + 1 #between 1 and 1000
        u_copy.password = "xty" + random_pw_number.to_s
        u_copy.password_confirmation = u_copy.password
        u_copy.password_temp = "xty" + random_pw_number.to_s

      # u_copy.persistence_token = user[7]
      # u_copy.single_access_token = user[8]
      # u_copy.perishable_token = user[9]
      u_copy.login_count = user[10].to_i
      u_copy.failed_login_count = user[11].to_i
      u_copy.last_request_at = user[12]
      u_copy.current_login_at = user[13]
      u_copy.last_login_at = user[14]
      u_copy.current_login_ip = user[15]
      u_copy.last_login_ip = user[16]
      # u_copy.created_at = user[17]
      # u_copy.updated_at = user[18]
      u_copy.time_zone = user[19]
      u_copy.update_number_active_goals = user[20].to_i
      u_copy.gender = user[21]
      # u_copy.yob = user[22].to_i
      u_copy.sponsor = user[23]
      u_copy.last_donation_date = user[27]
      u_copy.donated_so_far = user[29]
      u_copy.kill_ads_until = user[31]
      u_copy.unlimited_goals = user[32]
      u_copy.combine_daily_emails = user[34]
      u_copy.payments = user[35]
      u_copy.city = user[44]
      u_copy.state = user[45]
      u_copy.zip = user[46]
      u_copy.cost_per_period = user[53]
      u_copy.period = user[54]
      u_copy.subscriptionid = user[55]
      u_copy.subscriptionmessage = user[56]
      u_copy.plan = user[57]
      u_copy.premium_start_date = user[58]
      u_copy.premium_stop_date = user[59]
      u_copy.is_a_coach = user[60]
      u_copy.coach_id = user[61].to_i
      u_copy.sent_expire_warning_on = user[62]
      u_copy.sent_expire_notice_on = user[63]
      u_copy.opt_in_random_fire = user[64]
      u_copy.affiliate_id = user[65].to_i
      u_copy.is_affiliate = user[66]
      u_copy.active_goals_tallied_hour = user[67].to_i
      u_copy.password_temp = user[68]
      u_copy.goal_temp = user[69]
      u_copy.referer = user[70]
      u_copy.supportpoints = user[71].to_i
      u_copy.supportpoints_log = user[72]
      u_copy.promo_comeback_last_sent = user[76]
      u_copy.promo_comeback_token = user[77]
      u_copy.undeliverable = user[78]
      u_copy.undeliverable_date_checked = user[79]
      u_copy.last_activity_date = user[85]
      u_copy.show_gravatar = user[96]
      u_copy.impact_points = 0
      u_copy.feed_filter_show_my_categories_only = 1
      u_copy.feed_filter_hide_pmo = 1
      u_copy.hide_feed = 0


      u_copy.save!
      puts "new user ID:" + u_copy.id.to_s

      if !u_copy.handle
        u_copy.assign_unique_handle
        u_copy.save
        puts "handle: " + u_copy.handle
      end

      u = "copy made, user being updated: " + user[3]
      puts u
      logger.info("sgj:restore_old_user.rb:" + u )

      sql_update = "UPDATE users_pre_purge_201306 set copied_back = '1' where email = '" + user[3] + "'"
      update_old_user = ActiveRecord::Base.connection.execute(sql_update)

    end

  end
  #######
  # END 1. delete any data for users who have not had activity for 1 year
  # 
  #######

  puts "end of script"

end