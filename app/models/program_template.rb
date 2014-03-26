class ProgramTemplate < ActiveRecord::Base
  belongs_to :program
  
  ### the below might not work right... will have to test
  belongs_to :template, :class_name => 'Goal', :foreign_key => 'template_goal_id'

### how to reference via diff. names
### as per:
### https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-talk/hRM57xa3ztY
###    belongs_to :attribute_primary, :class_name => 'Attribute', :foreign_key => 'attribute_id'
###    belongs_to :attribute_secondary, :class_name => 'Attribute', :foreign_key => 'attribute_secondary_id'

  belongs_to :managed_by_user, :class_name => 'User', :foreign_key => 'managed_by_user_id'


  validates_uniqueness_of :template_goal_id, :scope => :program_id


  def get_next_listing_position
  	if self.listing_position and self.track_number
  		action_item = ProgramTemplate.find(:first, :conditions => "program_id = '#{self.program_id}' and listing_position > '#{self.listing_position}' and track_number = '#{self.track_number}'", :order => listing_position)
  		if action_item
  			return action_item.listing_position
  		else
  			return false
  		end
  	else
      return false
  	end
  end


end
