class AddReportsToCheers < ActiveRecord::Migration
  def self.up
  	add_column :cheers, :weekly_report, :boolean, :default => true
  	add_column :cheers, :weekly_report_last_sent, :date
  end

  def self.down
  	remove_column :cheers, :weekly_report
  	remove_column :cheers, :weekly_report_last_sent
  end
end
