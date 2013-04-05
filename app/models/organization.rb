class Organization < ActiveRecord::Base

### how to reference via diff. names
### as per:
### https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-talk/hRM57xa3ztY
###    belongs_to :attribute_primary, :class_name => 'Attribute', :foreign_key => 'attribute_id'
###    belongs_to :attribute_secondary, :class_name => 'Attribute', :foreign_key => 'attribute_secondary_id'

  belongs_to :managed_by_user, :class_name => 'User', :foreign_key => 'managed_by_user_id'

  has_many :organization_users
  has_many :users, :through => :organization_users

  has_many :programs

  has_many :levels

  has_many :triggers
  has_many :messages
  
  has_many :tags
end
