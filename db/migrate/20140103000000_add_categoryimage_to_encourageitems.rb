class AddCategoryimageToEncourageitems < ActiveRecord::Migration
  def self.up
  	add_column :encourage_items, :category_image_name, :string
  end

  def self.down
  	remove_column :encourage_items, :category_image_name
  end
end
