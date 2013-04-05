class ProgramTag < ActiveRecord::Base
  belongs_to :program
  belongs_to :tag
end
