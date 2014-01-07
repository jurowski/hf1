class AddDeletionwarningToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :deletion_warning, :date
  end

  def self.down
  	remove_column :users, :deletion_warning
  end
end
