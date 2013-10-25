class AddFacebookToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :fb_id, :integer
  	add_column :users, :fb_email, :string
  	add_column :users, :fb_username, :string
  	add_column :users, :fb_first_name, :string
  	add_column :users, :fb_last_name, :string
  	add_column :users, :fb_gender, :string
  	add_column :users, :fb_timezone, :string
  end

  def self.down
  	remove_column :users, :fb_id
  	remove_column :users, :fb_email
  	remove_column :users, :fb_username
  	remove_column :users, :fb_first_name
  	remove_column :users, :fb_last_name
  	remove_column :users, :fb_gender
  	remove_column :users, :fb_timezone
  end
end
