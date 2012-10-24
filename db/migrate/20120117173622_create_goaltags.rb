class CreateGoaltags < ActiveRecord::Migration
  def self.up
    create_table :goaltags do |t|
      t.integer :goaltemplate_id
      t.integer :tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :goaltags
  end
end
