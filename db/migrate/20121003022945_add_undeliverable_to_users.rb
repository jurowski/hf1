class AddUndeliverableToUsers < ActiveRecord::Migration
  def self.up
	add_column :users, :undeliverable, :boolean, :default => false
  end

  def self.down
	remove_column :users, :undeliverable
  end
end
