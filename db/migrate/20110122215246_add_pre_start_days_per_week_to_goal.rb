class AddPreStartDaysPerWeekToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :pre_start_days_per_week, :integer
  end

  def self.down
    remove_column :goals, :pre_start_days_per_week
  end
end
