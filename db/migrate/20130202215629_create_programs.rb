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

      t.string :catch_phrase
      t.integer :stale_after_days_of_silence_count
      t.string :difficulty_rating
      t.float :version_number
      t.string :status

      t.timestamps
    end
  end



  def self.down
   drop_table :programs
  end
end
