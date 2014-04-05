class AddProgramsuccessToGoals < ActiveRecord::Migration
  def self.up
  	add_column :goals, :program_met_goal_date, :date
  	add_column :goals, :program_met_goal_notification_text, :text
  	add_column :goals, :program_met_goal_need_to_notify_user_screen, :boolean
  	add_column :goals, :program_met_goal_need_to_notify_user_email, :boolean
  	add_column :goals, :program_met_goal_need_to_notify_feed, :boolean
  	add_column :goals, :program_met_goal_points, :integer
  	add_column :goals, :program_met_goal_badge, :string
  end

  def self.down
  	remove_column :goals, :program_goal_date
  	remove_column :goals, :program_met_goal_notification_text
  	remove_column :goals, :program_met_goal_need_to_notify_user_screen
  	remove_column :goals, :program_met_goal_need_to_notify_user_email
  	remove_column :goals, :program_met_goal_need_to_notify_feed
  	remove_column :goals, :program_met_goal_points
  	remove_column :goals, :program_met_goal_badge
  end
end
