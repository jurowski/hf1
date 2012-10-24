class AddRefererToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :referer, :string
  end

  def self.down
    remove_column :users, :referer
  end
end
