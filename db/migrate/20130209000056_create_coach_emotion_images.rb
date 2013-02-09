class CreateCoachEmotionImages < ActiveRecord::Migration
  def self.up
    create_table :coach_emotion_images do |t|
      t.integer :coach_user_id
      t.integer :emotion_id
      t.string :image_name

      t.timestamps
    end
  end

  def self.down
    drop_table :coach_emotion_images
  end
end
