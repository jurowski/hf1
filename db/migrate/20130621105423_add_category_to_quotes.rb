class AddCategoryToQuotes < ActiveRecord::Migration
  def self.up
  	add_column :quotes, :category, :string
  	add_column :quotes, :source, :string
  	add_column :quotes, :subject, :string
  end

  def self.down
  	remove_column :quotes, :category
  	remove_column :quotes, :source
  	remove_column :quotes, :subject
  end

end
