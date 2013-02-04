class CreateTriggers < ActiveRecord::Migration
  def self.up
    create_table :triggers do |t|
      t.boolean :shared
      t.integer :organization_id
      t.integer :program_id
      t.integer :template_goal_id
      t.boolean :trigger_for_silence_instead_of_reports
      t.boolean :trigger_for_failure_instead_of_success
      t.boolean :trigger_once_days_straight_success_or_failure
      t.boolean :trigger_once_lagging_rate_success_or_failure
      t.boolean :trigger_once_total_days_of_success_or_failure
      t.boolean :trigger_once_min_total_days_elapsed
      t.integer :min_total_days_elapsed
      t.integer :min_lag_days
      t.integer :min_success_or_failure_days
      t.integer :min_success_or_failure_rate
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :triggers
  end
end
