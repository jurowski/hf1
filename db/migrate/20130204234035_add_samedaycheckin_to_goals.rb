class AddSamedaycheckinToGoals < ActiveRecord::Migration
  def self.up
  	add_column :goals, :check_in_same_day, :boolean, :default => true
  end

  def self.down
  	remove_column :goals, :check_in_same_day
  end
end