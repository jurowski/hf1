class AddTempgoalToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :goal_temp, :string
  end

  def self.down
    remove_column :users, :goal_temp, :string
  end
end
