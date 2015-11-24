class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :event_type_id
      t.integer :user_id
      t.integer :goal_id
      t.integer :checkpoint_id
      t.datetime :expire_at_datetime
      t.datetime :valid_at_datetime
      t.date :valid_at_date
      t.date :expire_at_date
      t.integer :valid_at_hour
      t.integer :expire_at_hour

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
