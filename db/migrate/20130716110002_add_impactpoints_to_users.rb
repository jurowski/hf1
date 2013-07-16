class AddImpactpointsToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :impact_points, :integer
  end

  def self.down
  	remove_column :users, :impact_points
  end
end
