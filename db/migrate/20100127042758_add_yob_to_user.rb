class AddYobToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :yob, :integer
  end

  def self.down
    remove_column :users, :yob
  end
end
