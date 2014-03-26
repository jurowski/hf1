class AddTriggersToProgramtemplates < ActiveRecord::Migration
  def self.up
  	add_column :program_templates, :succeed_for_days_straight, :boolean
  	add_column :program_templates, :min_days_straight, :integer

  	add_column :program_templates, :succeed_for_lagging_success_rate, :boolean
  	add_column :program_templates, :lag_days, :integer
  	add_column :program_templates, :min_lag_success_rate, :integer

  	add_column :program_templates, :succeed_for_total_days_of_success, :boolean
  	add_column :program_templates, :min_success_days, :integer

  	add_column :program_templates, :succeed_for_momentum, :boolean
  	add_column :program_templates, :min_momentum, :integer

  end

  def self.down
  	remove_column :program_templates, :succeed_for_days_straight
  	remove_column :program_templates, :min_days_straight

  	remove_column :program_templates, :succeed_for_lagging_success_rate
  	remove_column :program_templates, :lag_days
  	remove_column :program_templates, :min_lag_success_rate

  	remove_column :program_templates, :succeed_for_total_days_of_success
  	remove_column :program_templates, :min_success_days

  	remove_column :program_templates, :succeed_for_momentum
  	remove_column :program_templates, :min_momentum
  end


end
