class AddCustomize1ToPrograms < ActiveRecord::Migration
  def self.up
  	add_column :programs, :actions_list_dropdown, :boolean
  end

  def self.down
  	remove_column :programs, :actions_list_dropdown
  end
end
