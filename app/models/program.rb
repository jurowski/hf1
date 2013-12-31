class Program < ActiveRecord::Base
  belongs_to :organization

  has_many :program_tags
  has_many :tags, :through => :program_tags

  has_many :program_enrollments
  has_many :program_sessions

  has_many :program_templates

  ### the below might not work right... will have to test
  has_many :templates, :through => :program_templates

### how to reference via diff. names
### as per:
### https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-talk/hRM57xa3ztY
###    belongs_to :attribute_primary, :class_name => 'Attribute', :foreign_key => 'attribute_id'
###    belongs_to :attribute_secondary, :class_name => 'Attribute', :foreign_key => 'attribute_secondary_id'

  belongs_to :managed_by_user, :class_name => 'User', :foreign_key => 'managed_by_user_id'


  has_many :levels
  has_many :triggers
  has_many :messages


  validates_uniqueness_of :name, :scope => :managed_by_user_id
end
