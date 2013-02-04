class CreateMessageGoals < ActiveRecord::Migration
  def self.up
    create_table :message_goals do |t|
      t.integer :message_id
      t.integer :goal_id
      t.integer :trigger_id
      t.date :sent_date
      t.datetime :sent_datetime
      t.string :sent_status
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :message_goals
  end
end
