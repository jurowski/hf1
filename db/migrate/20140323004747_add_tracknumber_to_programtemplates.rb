class AddTracknumberToProgramtemplates < ActiveRecord::Migration
  def self.up
  	add_column :program_templates, :track_number, :integer
  end

  def self.down
  	remove_column :program_templates, :track_number
  end
end
