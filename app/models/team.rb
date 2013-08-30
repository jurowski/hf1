require 'logger'
require 'date'
class Team < ActiveRecord::Base
  

  ### enabling the below will break new goal creation for goals that do not have a name
  ### so find a way to force a unique name if a new random team is being created
  #validates_uniqueness_of :name
  #validates_numericality_of :qty_max, :greater_than => 1, :less_than => 50 


  has_many :teamgoals
  has_many :goals, :through => :teamgoals

  belongs_to :goal_template_parent, :class_name => 'Goal', :foreign_key => 'goal_template_parent_id'

  def calc_has_openings_save
  	if !self.qty_max
  		self.qty_max = 0
  	end 

  	if !self.qty_current
  		self.qty_current = 0
  	end

  	if self.qty_current < self.qty_max
  		self.has_opening = true
  	else
  		self.has_opening = false
  	end

  	self.save
  end


  #### had to hack the below together b/c team.rb for some reason is not able to
  #### see the current_user function from application_controller.rb
  def i_am_owner_or_admin(user_id)
  	user_to_check = User.find(user_id)
  	if user_to_check
  		if user_to_check.is_admin
  			return true
  		else
	  		if self.owner_user_id == user_to_check.id
	  			return true
	  		else
	  			return false
	  		end
  		end

  	end

  end



end
