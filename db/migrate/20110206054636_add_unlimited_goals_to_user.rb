class AddUnlimitedGoalsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :unlimited_goals, :integer
  end

  def self.down
    remove_column :users, :unlimited_goals
  end
end
