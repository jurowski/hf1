class AddBadgesToProgramtemplates < ActiveRecord::Migration

  def self.up
  	add_column :program_templates, :points_for_success, :integer
  	add_column :program_templates, :badge_name, :string
  	add_column :program_templates, :badge_description, :text
  	add_column :program_templates, :tempt_image_name, :string
  	add_column :program_templates, :prize_image_name, :string
  end

  def self.down
  	remove_column :program_templates, :points_for_success
  	remove_column :program_templates, :badge_name
  	remove_column :program_templates, :badge_description
  	remove_column :program_templates, :tempt_image_name
  	remove_column :program_templates, :prize_image_name
  end

end
