class AddFirstgoalToLevels < ActiveRecord::Migration
  def self.up
    add_column :levels, :first_template_goal_id, :integer ### which template goal to start with in a level
  end

  def self.down
  	remove_column :levels, :first_template_goal_id
  end
end
