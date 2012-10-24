class AddPaymentsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :payments, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :users, :payments
  end
end
