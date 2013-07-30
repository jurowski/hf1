class AddGotfreemembershipToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :got_free_membership, :date
  end

  def self.down
  	remove_column :users, :got_free_membership
  end
end
