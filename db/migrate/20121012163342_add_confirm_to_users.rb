class AddConfirmToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :confirmed_address, :boolean, :default => false
    add_column :users, :confirmed_address_token, :string
  end

  def self.down
    remove_column :users, :confirmed_address
    remove_column :users, :confirmed_address_token
  end
end
