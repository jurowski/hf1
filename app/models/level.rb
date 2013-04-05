class Level < ActiveRecord::Base
  belongs_to :organization
  belongs_to :program

  ### the below might not work right... will have to test
  belongs_to :template, :class_name => 'Goal', :foreign_key => 'template_goal_id'

  ### the below might not work right... will have to test
  belongs_to :next_level, :class_name => 'Level', :foreign_key => 'next_level_id'

  ### the below might not work right... will have to test
  belongs_to :prize_message, :class_name => 'Message', :foreign_key => 'prize_message_id'

  belongs_to :trigger

  belongs_to :counter_images_set

  has_many :level_goals
  has_many :goals, :through => :level_goals


end
