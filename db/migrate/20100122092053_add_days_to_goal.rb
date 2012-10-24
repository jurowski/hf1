class AddDaysToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :days, :boolean
  end

  def self.down
    remove_column :goals, :days
  end
end
