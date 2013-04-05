class LevelGoal < ActiveRecord::Base
  belongs_to :level 
  belongs_to :goal 
end
