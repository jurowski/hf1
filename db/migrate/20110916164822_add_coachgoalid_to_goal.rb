class AddCoachgoalidToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :coachgoal_id, :integer
  end

  def self.down
    remove_column :goals, :coachgoal_id
  end
end
