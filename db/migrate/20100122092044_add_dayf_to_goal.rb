class AddDayfToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :dayf, :boolean
  end

  def self.down
    remove_column :goals, :dayf
  end
end
