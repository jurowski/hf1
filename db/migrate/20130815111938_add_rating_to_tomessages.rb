class AddRatingToTomessages < ActiveRecord::Migration
  def self.up
  	add_column :tomessages, :rating, :integer
  end

  def self.down
  	remove_column :tomessages, :rating
  end
end
