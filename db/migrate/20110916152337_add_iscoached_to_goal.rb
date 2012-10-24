class AddIscoachedToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :is_coached, :integer
  end

  def self.down
    remove_column :goals, :is_coached
  end
end
