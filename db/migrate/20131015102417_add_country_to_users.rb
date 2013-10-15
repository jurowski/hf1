class AddCountryToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :country, :string
  	add_column :users, :country_code, :string
  	add_column :users, :state_code, :string
  end

  def self.down
  	remove_column :users, :country
  	remove_column :users, :country_code
  	remove_column :users, :state_code
  end
end
