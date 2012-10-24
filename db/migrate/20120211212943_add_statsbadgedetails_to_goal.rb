class AddStatsbadgedetailsToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :last_stats_badge_details, :string
  end

  def self.down
    remove_column :goals, :last_stats_badge_details
  end
end
