class CoachTemplate < ActiveRecord::Base
  
  ### might not work, need to test
  belongs_to :coach_user, :class_name => 'User', :foreign_key => 'coach_user_id'

  ### might not work, need to test
  belongs_to :coach_template_goal, :class_name => 'Goal', :foreign_key => 'template_goal_id'
end
