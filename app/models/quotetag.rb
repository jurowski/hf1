class Quotetag < ActiveRecord::Base
    belongs_to :tag
    belongs_to :quote
end
