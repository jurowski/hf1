class EncourageItem < ActiveRecord::Base
	validates_uniqueness_of :checkpoint_id
end
