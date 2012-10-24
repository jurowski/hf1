class AddUsersendhourToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :usersendhour, :integer
  end

  def self.down
    remove_column :goals, :usersendhour
  end
end
