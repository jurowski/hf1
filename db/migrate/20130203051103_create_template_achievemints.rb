class CreateTemplateAchievemints < ActiveRecord::Migration
  def self.up
    create_table :template_achievemints do |t|
      t.integer :template_goal_id
      t.integer :achievemint_id

      t.timestamps
    end
  end

  def self.down
    drop_table :template_achievemints
  end
end
