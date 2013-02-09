class CreateMotivationTypes < ActiveRecord::Migration
  def self.up
    create_table :motivation_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :motivation_types
  end
end
