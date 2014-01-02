class AddDurationsToPrograms < ActiveRecord::Migration
  def self.up

  	### a duration can be a personalized start/stop date (handled w/in the program_enrollment record)
  	### OR a duration can be at the group/session level for start/stop date (handled w/in the program_session record)
  	add_column :programs, :duration_ongoing, :boolean, :default => true ### determines whether there will be any start or end date vs. ongoing
  	add_column :programs, :duration_is_in_months_bool, :boolean, :default => false ### used to both advertise and determine the length of the program
  	add_column :programs, :duration_is_in_weeks_bool, :boolean, :default => false ### used to both advertise and determine the length of the program
  	add_column :programs, :duration_is_in_days_bool, :boolean, :default => false ### used to both advertise and determine the length of the program
  	add_column :programs, :duration_qty, :integer, :default => 0 ### used to determine how many months, days or weeks for the program
  	add_column :programs, :duration_start_is_fixed, :boolean, :default => false ### bool determines whether the start date is fixed (program_enrollment.program_session.start_date) or up to the user (program_enrollment.start_date)
    add_column :programs, :structured, :boolean, :default => false ### whether joining a program is an all-or nothing instead of a-la-carte "choose various actions"
  end

  def self.down

  	remove_column :programs, :duration_ongoing
  	remove_column :programs, :duration_is_in_months_bool
  	remove_column :programs, :duration_is_in_weeks_bool
  	remove_column :programs, :duration_is_in_days_bool
  	remove_column :programs, :duration_qty
  	remove_column :programs, :duration_start_is_fixed
  	remove_column :programs, :structured
  end
end
