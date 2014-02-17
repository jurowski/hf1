class AddCountsToPrograms < ActiveRecord::Migration
  def self.up
  	add_column :programs, :count_of_enrolled_users, :integer
  end

  def self.down
  	remove_column :programs, :count_of_enrolled_users
  end
end
