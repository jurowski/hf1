class AddPointsToProgramenrollments < ActiveRecord::Migration
  def self.up
  	add_column :program_enrollments, :points_earned, :integer
  	add_column :program_enrollments, :success_log, :text
  end

  def self.down
  	remove_column :program_enrollments, :points_earned
  	remove_column :program_enrollments, :success_log
  end
end
