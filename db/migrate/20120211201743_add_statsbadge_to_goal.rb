class AddStatsbadgeToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :last_stats_badge, :string
    add_column :goals, :last_stats_badge_date, :date
  end

  def self.down
    remove_column :goals, :last_stats_badge_date
    remove_column :goals, :last_stats_badge
  end
end
