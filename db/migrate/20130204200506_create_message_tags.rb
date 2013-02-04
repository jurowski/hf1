class CreateMessageTags < ActiveRecord::Migration
  def self.up
    create_table :message_tags do |t|
      t.integer :tag_id
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :message_tags
  end
end
