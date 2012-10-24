class Coachgoal < ActiveRecord::Base
  belongs_to :goal
  belongs_to :user 
  belongs_to :coach
end
