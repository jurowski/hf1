class AddEmailToBetpayee < ActiveRecord::Migration
  def self.up
    add_column :betpayees, :email, :string
  end

  def self.down
    remove_column :betpayees, :email
  end
end
