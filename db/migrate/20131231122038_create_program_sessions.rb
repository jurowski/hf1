class CreateProgramSessions < ActiveRecord::Migration
  def self.up
    create_table :program_sessions do |t|
      t.integer :program_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :program_sessions
  end
end
