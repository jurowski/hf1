class AddGoalmomentumToEncourageitems < ActiveRecord::Migration
  def self.up
  	add_column :encourage_items, :goal_momentum, :integer, :default => 0
  end

  def self.down
  	remove_column :encourage_items, :goal_momentum
  end
end
