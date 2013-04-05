class TemplateTag < ActiveRecord::Base
  belongs_to :tag 

  ### the below might not work right... will have to test
  belongs_to :template, :class_name => 'Goal', :foreign_key => 'template_goal_id'


end
