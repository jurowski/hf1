class AddUndeliverabledatecheckedToUsers < ActiveRecord::Migration
  def self.up
	add_column :users, :undeliverable_date_checked, :date
  end

  def self.down
	remove_column :users, :undeliverable_date_checked
  end
end
