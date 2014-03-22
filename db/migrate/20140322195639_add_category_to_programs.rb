class AddCategoryToPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :category, :string
  end

  def self.down
  	remove_column :programs, :category
  end
end
