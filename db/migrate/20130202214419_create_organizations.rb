class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.integer :managed_by_user_id
      t.string :name
      t.text :about
      t.string :url
      t.string :email
      t.string :phone
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :image_logo

      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
