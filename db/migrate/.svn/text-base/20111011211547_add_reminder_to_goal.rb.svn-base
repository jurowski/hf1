class AddReminderToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :remind_me, :integer
    add_column :goals, :reminder_send_hour, :integer
    add_column :goals, :reminder_last_sent_date, :date
  end

  def self.down
    remove_column :goals, :reminder_last_sent_date
    remove_column :goals, :reminder_send_hour
    remove_column :goals, :remind_me
  end
end
