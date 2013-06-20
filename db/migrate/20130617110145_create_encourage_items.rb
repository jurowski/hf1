class CreateEncourageItems < ActiveRecord::Migration
  def self.up
    create_table :encourage_items do |t|
      t.boolean :encourage_type_new_checkpoint_bool
      t.boolean :encourage_type_new_goal_bool
      t.integer :checkpoint_id
      t.string :checkpoint_status
      t.date :checkpoint_date
      t.datetime :checkpoint_updated_at_datetime
      t.integer :goal_id
      t.string :goal_name
      t.string :goal_category
      t.datetime :goal_created_at_datetime
      t.boolean :goal_publish
      t.date :goal_first_start_date
      t.integer :goal_daysstraight
      t.integer :goal_days_into_it
      t.integer :goal_success_rate_percentage
      t.integer :user_id
      t.string :user_name
      t.string :user_email

      t.timestamps
    end
  end

  def self.down
    drop_table :encourage_items
  end
end

