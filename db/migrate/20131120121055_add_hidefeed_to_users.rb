class AddHidefeedToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :hide_feed, :boolean
  	add_column :users, :premium_only_complete_privacy, :boolean
  	add_column :users, :premium_only_default_private_goal, :boolean
  end

  def self.down
  	remove_column :users, :hide_feed
  	remove_column :users, :premium_only_complete_privacy
  	remove_column :users, :premium_only_default_private_goal
  end
end
