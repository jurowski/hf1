class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.date :recorddate
      t.integer :recordhour
      t.integer :usercount
      t.integer :goalcount
      t.integer :goalactivecount
      t.integer :goalsnewcreated
      t.integer :usersnewcreated
      t.integer :checkpointemailssent

      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
