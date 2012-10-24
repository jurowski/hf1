class Cheer < ActiveRecord::Base
  belongs_to :goal
  validates_uniqueness_of :email, :scope => :goal_id
end
