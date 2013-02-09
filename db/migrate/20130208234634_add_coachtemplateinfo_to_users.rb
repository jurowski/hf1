class AddCoachtemplateinfoToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :coach_organization_id, :integer
  	add_column :users, :coach_first_name, :string
  	add_column :users, :coach_last_name, :string
    add_column :users, :coach_gender, :string
    add_column :users, :coach_tagline, :string
    add_column :users, :coach_description, :text
    add_column :users, :coach_image_standard, :string
    add_column :users, :coach_contact_email, :string
    add_column :users, :coach_contact_phone, :string


  end

  def self.down
  	remove_column :users, :coach_organization_id
  	remove_column :users, :coach_first_name
  	remove_column :users, :coach_last_name
    remove_column :users, :coach_gender
    remove_column :users, :coach_tagline
    remove_column :users, :coach_description
    remove_column :users, :coach_image_standard
    remove_column :users, :coach_contact_email
    remove_column :users, :coach_contact_phone
  end
end
