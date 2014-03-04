class CreateLevels < ActiveRecord::Migration
  def self.up
    create_table :levels do |t|
      t.boolean :shared ### should this be visible to anyone defining levels
      t.integer :organization_id ### what organization is this a part of
      t.integer :program_id ### what program is this a part of 
      t.integer :template_goal_id ### what action or challenge am I doing at this level
      t.integer :next_level_id ### what level do I jump to if I pass this one
      t.boolean :this_is_the_first_level ### in a program, is this the action/level that people start with
      t.integer :points ### how many points will I earn for my program score for passing this level
      t.string :name ### what this level is called (short)
      t.text :description ### describe this level
      t.string :tempt_image_name ### filename of an image that is a teaser of a badge I will earn for passing
      t.integer :tempt_image_height 
      t.string :prize_image_name ### filename of a badge I will earn for passing
      t.integer :prize_image_height
      t.string :prize_url ### URL that will be available / unlocked? for passing
      t.integer :prize_message_id ### a congrats message for getting my prize when passing
      t.integer :trigger_id ### the criteria for passing this level
      t.integer :counter_images_set_id ### which "days in a row" images to use at this level

      t.timestamps
    end
  end

  def self.down
    drop_table :levels
  end
end
