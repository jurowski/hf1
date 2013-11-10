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


	def measurement_display
		measurement_with_decimals = self.measurement.to_f / 100
		m_display = measurement_with_decimals.to_s

		### check if you really need that precision
		arr_measurement = measurement_with_decimals.to_s.split(".")
		if arr_measurement[1] == "00" or arr_measurement[1] == "0"
			m_display = arr_measurement[0]
		end
		return m_display 
	end



end
