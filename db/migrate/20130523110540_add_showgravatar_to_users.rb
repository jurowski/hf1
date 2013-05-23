class AddShowgravatarToUsers < ActiveRecord::Migration
  def self.up
 	add_column :users, :show_gravatar, :boolean, :default => true
  end

  def self.down
  	remove_column :users, :show_gravatar
  end
end
