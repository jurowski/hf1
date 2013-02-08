class AddNumbergoalsifollowToUsers < ActiveRecord::Migration
  def self.up
 	add_column :users, :update_number_active_goals_i_follow, :integer, :default => 0
 	add_column :users, :active_goals_i_follow_tallied_hour, :integer, :default => 0
  end


  def self.down
  	remove_column :users, :update_number_active_goals_i_follow
  	remove_column :users, :active_goals_i_follow_tallied_hour
  end
end
