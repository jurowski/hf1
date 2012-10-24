class AddIndexToCheckpoints < ActiveRecord::Migration
  def self.up
    add_index :checkpoints, :goal_id
  end

  def self.down
  end
end
