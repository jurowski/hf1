class CreateCheckpoints < ActiveRecord::Migration
  def self.up
    create_table :checkpoints do |t|
      t.date :checkin_date
      t.time :checkin_time
      t.string :status, :default => "not yet due"
      t.integer :goal_id

      t.timestamps
    end
  end

  def self.down
    drop_table :checkpoints
  end
end
