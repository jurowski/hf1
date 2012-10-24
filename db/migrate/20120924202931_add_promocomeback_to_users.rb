class AddPromocomebackToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :promo_comeback_last_sent, :date
    add_column :users, :promo_comeback_token, :string
  end

  def self.down
    remove_column :users, :promo_comeback_last_sent
    remove_column :users, :promo_comeback_token
  end
end
