class CreateMessageEmotions < ActiveRecord::Migration
  def self.up
    create_table :message_emotions do |t|
      t.integer :message_id
      t.integer :emotion_id

      t.timestamps
    end
  end

  def self.down
    drop_table :message_emotions
  end
end
