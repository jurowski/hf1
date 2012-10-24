class Quote < ActiveRecord::Base
  has_many :quotetags
  has_many :tags, :through => :quotetags
end
