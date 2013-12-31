class ProgramSession < ActiveRecord::Base
belongs_to :program
has_many :program_enrollments
end
