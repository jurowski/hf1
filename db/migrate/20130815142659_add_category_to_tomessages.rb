class AddCategoryToTomessages < ActiveRecord::Migration
  	add_column :tomessages, :category, :string
  	add_column :tomessages, :message_type, :string
  end

  def self.down
  	remove_column :tomessages, :category
  	remove_column :tomessages, :message_type
end
