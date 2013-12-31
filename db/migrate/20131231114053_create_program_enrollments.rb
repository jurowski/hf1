class CreateProgramEnrollments < ActiveRecord::Migration
  def self.up
    create_table :program_enrollments do |t|
      t.integer :program_id ### which program is it
      t.integer :user_id
      t.boolean :active ### bool turning it on or off
      t.boolean :ongoing ### bool whether stop/start dates are relevant ... if true, then not part of a program_session
      t.integer :program_session_id ### if belonging to a group session start/stop date (ie a program that has a set start date)
      t.date :personal_start_date ###optional ... relevant if the start date depends on the individual ... see parent program
      t.date :personal_end_date ###optional ... see parent program

      t.timestamps
    end
  end

  def self.down
    drop_table :program_enrollments
  end
end
