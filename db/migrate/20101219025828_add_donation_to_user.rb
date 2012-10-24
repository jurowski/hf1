class AddDonationToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :last_donation_date, :date
    add_column :users, :last_donation_plea_date, :date
    add_column :users, :donated_so_far, :integer
  end

  def self.down
    remove_column :users, :donated_so_far
    remove_column :users, :last_donation_plea_date
    remove_column :users, :last_donation_date
  end
end
