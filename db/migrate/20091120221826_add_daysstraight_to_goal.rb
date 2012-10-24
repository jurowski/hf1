class AddDaysstraightToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :daysstraight, :integer
  end

  def self.down
    remove_column :goals, :daysstraight
  end
end
