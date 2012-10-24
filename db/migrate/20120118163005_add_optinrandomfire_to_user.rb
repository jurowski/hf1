class AddOptinrandomfireToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :opt_in_random_fire, :integer
  end

  def self.down
    remove_column :users, :opt_in_random_fire
  end
end
