class AddCategoryToFrommessages < ActiveRecord::Migration
  def self.up
  	add_column :frommessages, :category, :string
  	add_column :frommessages, :message_type, :string
  end

  def self.down
  	remove_column :frommessages, :category
  	remove_column :frommessages, :message_type
  end
end
