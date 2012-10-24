class AddTeamidToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :team_id, :integer
  end

  def self.down
    remove_column :goals, :team_id
  end
end
