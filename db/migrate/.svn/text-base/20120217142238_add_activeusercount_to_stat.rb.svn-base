class AddActiveusercountToStat < ActiveRecord::Migration
  def self.up
    add_column :stats, :activeusercount, :integer
    add_column :stats, :activegoalcount, :integer
  end

  def self.down
    remove_column :stats, :activegoalcount
    remove_column :stats, :activeusercount
  end
end
