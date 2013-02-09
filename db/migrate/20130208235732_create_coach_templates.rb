class CreateCoachTemplates < ActiveRecord::Migration
  def self.up
    create_table :coach_templates do |t|
      t.integer :coach_user_id
      t.integer :template_goal_id

      t.timestamps
    end
  end

  def self.down
    drop_table :coach_templates
  end
end
