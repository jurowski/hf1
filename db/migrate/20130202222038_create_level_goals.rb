class CreateLevelGoals < ActiveRecord::Migration
  def self.up
    create_table :level_goals do |t|
      t.integer :level_id
      t.integer :goal_id
      t.string :prize_message_status
      t.integer :points
      t.text :notes
      t.date :date_achieved
      t.integer :success_rate
      t.integer :success_count
      t.integer :days_in
      t.string :name
      t.text :description
      t.string :prize_image_name
      t.integer :prize_image_height
      t.string :prize_url

      t.timestamps
    end
  end

  def self.down
    drop_table :level_goals
  end
end
