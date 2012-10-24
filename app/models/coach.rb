class Coach < ActiveRecord::Base
  belongs_to :user 
  has_many :coachgoals
end
