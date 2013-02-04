class CreateLevels < ActiveRecord::Migration
  def self.up
    create_table :levels do |t|
      t.boolean :shared
      t.integer :organization_id
      t.integer :program_id
      t.integer :template_goal_id
      t.integer :next_level_id
      t.boolean :this_is_the_first_level
      t.boolean :success_once_days_straight
      t.boolean :success_once_lagging_rate
      t.boolean :success_once_total_success_days
      t.boolean :success_once_min_days_elapsed
      t.integer :min_days_elapsed
      t.integer :min_lag_days
      t.integer :min_success_days
      t.integer :min_success_rate
      t.integer :points
      t.string :name
      t.text :description
      t.string :tempt_image_name
      t.integer :tempt_image_height
      t.string :prize_image_name
      t.integer :prize_image_height
      t.string :prize_url
      t.integer :prize_message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :levels
  end
end
