class CreateCounterImages < ActiveRecord::Migration
  def self.up
    create_table :counter_images do |t|
      t.integer :counter_images_set_id
      t.integer :count
      t.string :image_name

      t.timestamps
    end
  end

  def self.down
    drop_table :counter_images
  end
end
