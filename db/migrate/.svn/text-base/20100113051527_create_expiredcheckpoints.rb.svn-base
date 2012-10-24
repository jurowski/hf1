class CreateExpiredcheckpoints < ActiveRecord::Migration
  def self.up
    create_table :expiredcheckpoints do |t|
      t.date :checkin_date
      t.time :checkin_time
      t.string :status
      t.integer :goal_id
      t.datetime :created_at
      t.datetime :updated_at
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :expiredcheckpoints
  end
end
