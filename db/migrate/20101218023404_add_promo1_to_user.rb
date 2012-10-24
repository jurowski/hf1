class AddPromo1ToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :unsubscribed_from_promo_emails, :integer
    add_column :users, :promo_1_token, :string
    add_column :users, :promo_1_sent, :integer
  end

  def self.down
    remove_column :users, :promo_1_sent
    remove_column :users, :promo_1_token
    remove_column :users, :unsubscribed_from_promo_emails
  end
end
