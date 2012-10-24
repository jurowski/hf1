class AddTemppwToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :password_temp, :string
  end

  def self.down
    remove_column :users, :password_temp, :string
  end
end
