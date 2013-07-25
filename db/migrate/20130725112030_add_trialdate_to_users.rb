class AddTrialdateToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :date_of_signup, :date
  end

  def self.down
  	remove_column :users, :date_of_signup
  end
end
