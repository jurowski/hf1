class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.integer :organization_id
      t.integer :managed_by_user_id
      t.string :image_logo
      t.string :name
      t.text :about
      t.text :joined_count
      t.text :current_count
      t.integer :rating_stars
      t.integer :rating_votes

      t.timestamps
    end
  end

  def self.down
    drop_table :programs
  end
end
