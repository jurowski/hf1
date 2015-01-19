class AddCategoryToUsers < ActiveRecord::Migration
  def self.up
	add_column :users, :category_first, :string
	add_column :users, :goal_first, :string
	add_column :users, :categories_goals, :text
  end

  def self.down
  	remove_column :users, :category_first
  	remove_column :users, :goal_first
  	remove_column :users, :categories_goals
  end
end
