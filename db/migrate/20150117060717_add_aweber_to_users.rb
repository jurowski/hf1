class AddAweberToUsers < ActiveRecord::Migration
  def self.up
	add_column :users, :lyphted_subscribe, :date
	add_column :users, :lyphted_unsubscribe, :date
  end

  def self.down
  	remove_column :users, :lyphted_subscribe
  	remove_column :users, :lyphted_unsubscribe
  end
end
