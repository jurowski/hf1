class Message < ActiveRecord::Base
  belongs_to :organization
  belongs_to :program
  belongs_to :trigger

  ### the below might not work right... will have to test
  belongs_to :template, :class_name => 'Goal', :foreign_key => 'template_goal_id'

  has_many :message_tags
  has_many :tags, :through => :message_tags

  #### had to hack the below together b/c message.rb for some reason is not able to
  #### see the current_user function from application_controller.rb
  def i_am_owner_or_admin(user_id)
  	user_to_check = User.find(user_id)
  	if user_to_check
  		if user_to_check.is_admin
  			return true
  		else
  			### currently only "program" aware
	  		if self.program and self.program.i_am_owner_or_admin(user_id)
	  			return true
	  		else
	  			return false
	  		end
  		end

  	end

  end ### end def i_am_owner_or_admin(user_id)




end
