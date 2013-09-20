require 'logger'
require 'date'
class Quant < ActiveRecord::Base
	belongs_to :user
	belongs_to :goal
	
	#attr_accessor :some_function_name
	validates_presence_of :goal_id, :user_id, :measurement

	#### had to hack the below together b/c team.rb for some reason is not able to
	#### see the current_user function from application_controller.rb
	def i_am_owner_or_admin(user_id)
		user_to_check = User.find(user_id)
		if user_to_check
			if user_to_check.is_admin
				return true
			else
	  		if self.user_id == user_to_check.id
	  			return true
	  		else
	  			return false
	  		end
			end
		end
	end ### end def i_am_owner_or_admin


end
