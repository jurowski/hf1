class CreateProgramTags < ActiveRecord::Migration
  def self.up
    create_table :program_tags do |t|
      t.integer :program_id
      t.integer :tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :program_tags
  end
end
