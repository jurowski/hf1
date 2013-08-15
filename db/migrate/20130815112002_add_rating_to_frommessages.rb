class AddRatingToFrommessages < ActiveRecord::Migration
  def self.up
  	add_column :frommessages, :rating, :integer
  end

  def self.down
  	remove_column :frommessages, :rating
  end
end
