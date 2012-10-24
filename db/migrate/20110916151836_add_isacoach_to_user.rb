class AddIsacoachToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_a_coach, :integer
  end

  def self.down
    remove_column :users, :is_a_coach
  end
end
