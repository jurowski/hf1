class AddIncludeonhomepageToPrograms < ActiveRecord::Migration
  def self.up
  	add_column :programs, :include_on_home_page, :boolean
  end

  def self.down
  	remove_column :programs, :include_on_home_page
  end
end
