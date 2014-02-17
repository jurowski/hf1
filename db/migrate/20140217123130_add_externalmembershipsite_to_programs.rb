class AddExternalmembershipsiteToPrograms < ActiveRecord::Migration
  def self.up
  	add_column :programs, :requires_external_membership, :boolean
  	add_column :programs, :link_image_to_external_site, :boolean
  	add_column :programs, :external_membership_url, :string
  	add_column :programs, :external_membership_text, :string
  end

  def self.down
  	remove_column :programs, :requires_external_membership
  	remove_column :programs, :link_image_to_external_site
  	remove_column :programs, :external_membership_url
  	remove_column :programs, :external_membership_text
  end



end
