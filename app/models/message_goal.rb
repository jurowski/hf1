class MessageGoal < ActiveRecord::Base
  belongs_to :message 
  belongs_to :goal 
  belongs_to :trigger	

end
