class CreateTemplateTags < ActiveRecord::Migration
  def self.up
    create_table :template_tags do |t|
      t.integer :tag_id
      t.integer :template_goal_id

      t.timestamps
    end
  end

  def self.down
    drop_table :template_tags
  end
end
