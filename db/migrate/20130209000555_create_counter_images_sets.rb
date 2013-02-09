class CreateCounterImagesSets < ActiveRecord::Migration
  def self.up
    create_table :counter_images_sets do |t|
      t.string :counter_set_name
      t.integer :counter_limit_number

      t.timestamps
    end
  end

  def self.down
    drop_table :counter_images_sets
  end
end
