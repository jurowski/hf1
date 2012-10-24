class AddPushToGoals < ActiveRecord::Migration
  def self.up
	add_column :goals, :allow_push, :boolean, :default => false
	add_column :goals, :phrase1, :string
	add_column :goals, :phrase2, :string
	add_column :goals, :phrase3, :string
	add_column :goals, :phrase4, :string
	add_column :goals, :phrase5, :string
  end

  def self.down
	remove_column :goals, :allow_push
	remove_column :goals, :phrase1
	remove_column :goals, :phrase2
	remove_column :goals, :phrase3
	remove_column :goals, :phrase4
	remove_column :goals, :phrase5
  end
end
