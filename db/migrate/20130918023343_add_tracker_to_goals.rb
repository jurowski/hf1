class AddTrackerToGoals < ActiveRecord::Migration
  def self.up


    add_column :goals, :tracker, :boolean  ### converts the goal to a quantity goal... meaning the corresponding yes/no gets auto-answered based on quants being in range between good1 and bad1
    add_column :goals, :tracker_question, :string ### completely freeform... ie: how many times today did i... or "what is my current..."
    add_column :goals, :tracker_statement, :string ### compeletely freeform... ie: my current mood is... or "i weigh..." or "my level of xxx is at...""
    add_column :goals, :tracker_units, :string
    add_column :goals, :tracker_digits_after_decimal, :integer ### how precise do we need to be
    add_column :goals, :tracker_standard_deviation_from_last_measurement, :integer ### for help generating quick current value links in email
    add_column :goals, :tracker_type_starts_at_zero_daily, :boolean, :default => true ### measuring sales calls you make, pushups you do, glasses of water you drink (if false, it's a thing that "is" that fluctuates, like weight or mood)
    add_column :goals, :tracker_target_higher_value_is_better, :boolean, :default => true
    add_column :goals, :tracker_target_threshold_bad1, :decimal ### keep an eye on it (one boundary of "normal")
    add_column :goals, :tracker_target_threshold_bad2, :decimal ### into a 2nd level of bad
    add_column :goals, :tracker_target_threshold_bad3, :decimal ### into a 3rd level of bad
    add_column :goals, :tracker_target_threshold_good1, :decimal ### upper boundary of "normal"
    add_column :goals, :tracker_target_threshold_good2, :decimal ### into a 2nd level of good 
    add_column :goals, :tracker_target_threshold_good3, :decimal ### into a 3rd level of "normal"
    add_column :goals, :tracker_measurement_worst_yet, :decimal
    add_column :goals, :tracker_measurement_best_yet, :decimal
    add_column :goals, :tracker_measurement_last_taken_on_date, :date
    add_column :goals, :tracker_measurement_last_taken_on_hour, :integer
    add_column :goals, :tracker_measurement_last_taken_value, :decimal
    add_column :goals, :tracker_measurement_last_taken_timestamp, :datetime

  end

  def self.down
  	remove_column :goals, :tracker
  	remove_column :goals, :tracker_question
  	remove_column :goals, :tracker_statement
  	remove_column :goals, :tracker_units
  	remove_column :goals, :tracker_digits_after_decimal
  	remove_column :goals, :tracker_standard_deviation_from_last_measurement
  	remove_column :goals, :tracker_type_starts_at_zero_daily
  	remove_column :goals, :tracker_target_higher_value_is_better
  	remove_column :goals, :tracker_target_threshold_bad1
  	remove_column :goals, :tracker_target_threshold_bad2
  	remove_column :goals, :tracker_target_threshold_bad3
  	remove_column :goals, :tracker_target_threshold_good1
  	remove_column :goals, :tracker_target_threshold_good2
  	remove_column :goals, :tracker_target_threshold_good3
  	remove_column :goals, :tracker_measurement_worst_yet
  	remove_column :goals, :tracker_measurement_best_yet
  	remove_column :goals, :tracker_measurement_last_taken_on_date
  	remove_column :goals, :tracker_measurement_last_taken_on_hour
  	remove_column :goals, :tracker_measurement_last_taken_value
  	remove_column :goals, :tracker_measurement_last_taken_timestamp

  end
end
