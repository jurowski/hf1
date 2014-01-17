class AddAskjobsfailuresToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :asked_for_job_lead_on_failure, :date
  end

  def self.down
  	remove_column :users, :asked_for_job_lead_on_failure
  end
end
