class AddMoreremindersToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :more_reminders_enabled, :boolean, :default => false
    add_column :goals, :more_reminders_start, :integer, :default => 8
    add_column :goals, :more_reminders_end, :integer, :default => 22
    add_column :goals, :more_reminders_every_n_hours, :integer, :default => 4    
    add_column :goals, :more_reminders_last_sent, :integer, :default => 0
  end

  def self.down
    remove_column :goals, :more_reminders_last_sent
    remove_column :goals, :more_reminders_every_n_hours
    remove_column :goals, :more_reminders_end
    remove_column :goals, :more_reminders_start
    remove_column :goals, :more_reminders_enabled
  end
end
