class CreateQuotetags < ActiveRecord::Migration
  def self.up
    create_table :quotetags do |t|
      t.integer :tag_id
      t.integer :quote_id

      t.timestamps
    end
  end

  def self.down
    drop_table :quotetags
  end
end
