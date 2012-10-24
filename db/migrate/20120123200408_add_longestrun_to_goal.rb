class AddLongestrunToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :longestrun, :integer
  end

  def self.down
    remove_column :goals, :longestrun
  end
end
