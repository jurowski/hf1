class AddGooglesignupToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :google_user_id, :integer
  	add_column :users, :google_email, :string
  end

  def self.down
  	remove_column :users, :google_user_id
  	remove_column :users, :google_email
  end
end
