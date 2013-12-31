class ProgramEnrollment < ActiveRecord::Base
belongs_to :program
belongs_to :program_session
end
