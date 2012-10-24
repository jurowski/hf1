class AddPushdetailsToGoals < ActiveRecord::Migration
  def self.up
	add_column :goals, :last_success_date, :date
	add_column :goals, :next_push_on_or_after_date, :date
	add_column :goals, :pushes_allowed_per_day, :integer
	add_column :goals, :pushes_remaining_on_next_push_date, :integer
  end

  #def self.down
 #	remove_column :goals, :last_success_date
 #	remove_column :goals, :next_push_on_or_after_date
 #	remove_column :goals, :pushes_allowed_per_day
 #	remove_column :goals, :pushes_remaining_on_next_push_date
 # end
end
