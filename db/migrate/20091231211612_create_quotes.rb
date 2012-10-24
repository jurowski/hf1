class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.text :thought
      t.string :author
      t.date :last_used
      t.boolean :priority

      t.timestamps
    end
  end

  def self.down
    drop_table :quotes
  end
end
