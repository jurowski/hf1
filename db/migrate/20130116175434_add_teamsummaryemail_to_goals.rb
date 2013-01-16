class AddTeamsummaryemailToGoals < ActiveRecord::Migration
  def self.up
    add_column :goals, :team_summary_send_hour, :integer, :default => 12
    add_column :goals, :team_summary_last_sent_date, :integer
  end

  def self.down
    remove_column :goals, :team_summary_send_hour
    remove_column :goals, :team_summary_last_sent_date
  end
end
