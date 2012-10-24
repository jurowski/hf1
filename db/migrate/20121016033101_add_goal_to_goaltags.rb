class AddGoalToGoaltags < ActiveRecord::Migration
  def self.up
    add_column :goaltags, :goal_id, :integer
  end

  def self.down
    remove_column :goaltags, :goal_id
  end
end
