class AddProgramToGoals < ActiveRecord::Migration
  def self.up
  	add_column :goals, :goal_added_through_template_from_program_id, :integer  	
  end

  def self.down
  	remove_column :goals, :goal_added_through_template_from_program_id
  end
end
