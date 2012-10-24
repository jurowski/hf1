class Goaltemplate < ActiveRecord::Base
    has_many :goaltags
    has_many :goals
    has_many :tags, :through => :goaltags
end
