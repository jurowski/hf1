class AddTemplatesToGoals < ActiveRecord::Migration
  def self.up
    add_column :goals, :template_owner_is_a_template, :boolean
    add_column :goals, :template_owner_advertise_me, :boolean
    add_column :goals, :template_user_parent_goal_id, :integer
    add_column :goals, :achievemint_points_earned, :integer
    add_column :goals, :level_points_earned, :integer
    add_column :goals, :template_current_level_id, :integer
    add_column :goals, :template_let_user_choose_any_level_bool, :boolean
    add_column :goals, :template_let_user_choose_lower_levels_bool, :boolean
    add_column :goals, :template_on_level_success_go_to_next_goal_bool, :boolean
    add_column :goals, :template_on_level_success_go_to_next_level_bool, :boolean
    add_column :goals, :template_on_level_success_stop_goal_bool, :boolean
    add_column :goals, :template_let_user_decide_when_to_move_to_next_goal_bool, :boolean
    add_column :goals, :template_next_template_goal_id, :integer

  end


  def self.down
    remove_column :goals, :template_owner_is_a_template
    remove_column :goals, :template_owner_advertise_me
    remove_column :goals, :template_user_parent_goal_id
    remove_column :goals, :achievemint_points_earned
    remove_column :goals, :level_points_earned
    remove_column :goals, :template_current_level_id
    remove_column :goals, :template_let_user_choose_any_level_bool
    remove_column :goals, :template_let_user_choose_lower_levels_bool
    remove_column :goals, :template_on_level_success_go_to_next_goal_bool
    remove_column :goals, :template_on_level_success_go_to_next_level_bool
    remove_column :goals, :template_on_level_success_stop_goal_bool
    remove_column :goals, :template_let_user_decide_when_to_move_to_next_goal_bool
    remove_column :goals, :template_next_template_goal_id
  end

end