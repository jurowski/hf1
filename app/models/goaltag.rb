class Goaltag < ActiveRecord::Base
    belongs_to :tag
    belongs_to :goal
end
