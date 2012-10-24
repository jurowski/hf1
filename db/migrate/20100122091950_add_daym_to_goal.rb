class AddDaymToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :daym, :boolean
  end

  def self.down
    remove_column :goals, :daym
  end
end
