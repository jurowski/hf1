class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text :refcode
      t.boolean :shared
      t.integer :organization_id
      t.integer :program_id
      t.integer :template_goal_id
      t.string :subject
      t.text :body
      t.text :language
      t.string :source
      t.boolean :random_quote
      t.boolean :insert_in_checkin_emails
      t.boolean :insert_in_reminder_emails
      t.boolean :insert_in_webpage
      t.boolean :separate_email
      t.boolean :for_the_team
      t.boolean :for_an_individial
      t.boolean :for_the_system
      t.date :for_this_date_only
      t.date :not_before_this_date
      t.date :not_after_this_date
      t.integer :trigger_id
      t.integer :allow_repeats_after_min_days
      t.boolean :this_is_one_of_the_actual_checkin_questions_bool
      t.boolean :this_is_a_random_congrats_message_bool
      t.boolean :this_is_a_random_sorry_message_bool
      t.boolean :this_is_a_random_push_bool
      t.boolean :allow_from_coach_bool
      t.boolean :allow_from_team_member_bool
      t.boolean :allow_from_follower_bool
      
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
