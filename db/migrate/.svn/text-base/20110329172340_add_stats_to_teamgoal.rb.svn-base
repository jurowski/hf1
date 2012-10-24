class AddStatsToTeamgoal < ActiveRecord::Migration
  def self.up
    add_column :teamgoals, :rank, :integer
    add_column :teamgoals, :success_rate, :integer
    add_column :teamgoals, :days_in_a_row, :integer
    add_column :teamgoals, :met_goal_last_week, :integer
    add_column :teamgoals, :last_checkin_date, :date
  end

  def self.down
    remove_column :teamgoals, :last_checkin_date
    remove_column :teamgoals, :met_goal_last_week
    remove_column :teamgoals, :days_in_a_row
    remove_column :teamgoals, :success_rate
    remove_column :teamgoals, :rank
  end
end
