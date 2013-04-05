class Message < ActiveRecord::Base
  belongs_to :organization
  belongs_to :program
  belongs_to :trigger

  ### the below might not work right... will have to test
  belongs_to :template, :class_name => 'Goal', :foreign_key => 'template_goal_id'

  has_many :message_tags
  has_many :tags, :through => :message_tags


end
