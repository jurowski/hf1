class AddPleasureToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :pleasure, :text
  end

  def self.down
    remove_column :goals, :pleasure
  end
end
