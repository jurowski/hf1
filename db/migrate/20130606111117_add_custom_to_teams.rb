class AddCustomToTeams < ActiveRecord::Migration
  def self.up
  	add_column :teams, :goal_template_parent_id, :integer  
  	add_column :teams, :custom, :boolean	
  	add_column :teams, :owner_user_id, :integer
  end

  def self.down
  	remove_column :teams, :goal_template_parent_id
  	remove_column :teams, :custom
  	remove_column :teams, :owner_user_id
  end
end
