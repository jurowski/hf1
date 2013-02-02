class CreateProgramTemplates < ActiveRecord::Migration
  def self.up
    create_table :program_templates do |t|
      t.integer :program_id
      t.integer :template_goal_id

      t.timestamps
    end
  end

  def self.down
    drop_table :program_templates
  end
end
