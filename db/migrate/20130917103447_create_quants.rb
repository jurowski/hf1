class CreateQuants < ActiveRecord::Migration
  def self.up
    create_table :quants do |t|

      t.integer :user_id # for convenience of knowing whose this is
      t.integer :goal_id # what goal this is for

      t.decimal :measurement # the recorded value

      t.datetime :measurement_taken_timestamp
      t.date :measurement_date
      t.integer :measurement_hour

      t.timestamps
    end
  end

  def self.down
    drop_table :quants
  end
end
