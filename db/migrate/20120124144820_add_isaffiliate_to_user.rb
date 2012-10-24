class AddIsaffiliateToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_affiliate, :integer
  end

  def self.down
    remove_column :users, :is_affiliate
  end
end
