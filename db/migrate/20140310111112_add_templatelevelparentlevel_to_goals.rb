class AddTemplatelevelparentlevelToGoals < ActiveRecord::Migration
  def self.up
    add_column :goals, :template_level_parent_level_id, :integer ### when part of a structured program, what level grouping am i in
  end

  def self.down
  	remove_column :goals, :template_level_parent_level_id
  end
end
