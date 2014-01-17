class AddAskjobsToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :asked_for_job_lead_on, :date
  end

  def self.down
  	remove_column :users, :asked_for_job_lead_on
  end
end
