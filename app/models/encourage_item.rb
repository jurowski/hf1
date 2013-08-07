class EncourageItem < ActiveRecord::Base
	validates_uniqueness_of :checkpoint_id, :scope => :goal_id
end
