class AddActivegoalsifollowtallyToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :active_goals_i_follow_tallied_date, :date  	
  end

  def self.down
  	remove_column :users, :active_goals_i_follow_tallied_date 	
  end
end
