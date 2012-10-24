class AddDaywToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :dayw, :boolean
  end

  def self.down
    remove_column :goals, :dayw
  end
end
