class CreateProgramMotivationTypes < ActiveRecord::Migration
  def self.up
    create_table :program_motivation_types do |t|
      t.integer :program_id
      t.integer :motivation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :program_motivation_types
  end
end
