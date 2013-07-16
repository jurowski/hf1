class AddSuccessratesToTeams < ActiveRecord::Migration
  def self.up
  	add_column :teams, :success_rate_during_past_7_days, :integer
  	add_column :teams, :success_rate_during_past_14_days, :integer
  	add_column :teams, :success_rate_during_past_21_days, :integer
  	add_column :teams, :success_rate_during_past_30_days, :integer
  	add_column :teams, :success_rate_during_past_60_days, :integer
  	add_column :teams, :success_rate_during_past_90_days, :integer
  	add_column :teams, :success_rate_during_past_180_days, :integer
  	add_column :teams, :success_rate_during_past_270_days, :integer
  	add_column :teams, :success_rate_during_past_365_days, :integer
  end

  def self.down
  	remove_column :teams, :success_rate_during_past_7_days
  	remove_column :teams, :success_rate_during_past_14_days
  	remove_column :teams, :success_rate_during_past_21_days
  	remove_column :teams, :success_rate_during_past_30_days
  	remove_column :teams, :success_rate_during_past_60_days
  	remove_column :teams, :success_rate_during_past_90_days
  	remove_column :teams, :success_rate_during_past_180_days
  	remove_column :teams, :success_rate_during_past_270_days
  	remove_column :teams, :success_rate_during_past_365_days
  end

end
