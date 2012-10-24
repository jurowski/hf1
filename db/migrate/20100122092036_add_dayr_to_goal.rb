class AddDayrToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :dayr, :boolean
  end

  def self.down
    remove_column :goals, :dayr
  end
end
