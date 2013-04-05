class Trigger < ActiveRecord::Base
  belongs_to :organization
  belongs_to :program

  ### the below might not work right... will have to test
  belongs_to :template, :class_name => 'Goal', :foreign_key => 'template_goal_id'

  has_many :messages

end
