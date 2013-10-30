class AddTrackerpromptToGoals < ActiveRecord::Migration
  def self.up
  	add_column :goals, :tracker_prompt_after_n_days_without_entry, :integer
  	add_column :goals, :tracker_prompt_for_an_initial_value, :boolean
  	add_column :goals, :tracker_track_difference_between_initial_and_latest, :boolean
  	add_column :goals, :tracker_difference_between_initial_and_latest, :decimal
  end

  def self.down
  	remove_column :goals, :tracker_prompt_after_n_days_without_entry
  	remove_column :goals, :tracker_prompt_for_an_initial_value
  	remove_column :goals, :tracker_track_difference_between_initial_and_latest
  	remove_column :goals, :tracker_difference_between_initial_and_latest
  end
end
