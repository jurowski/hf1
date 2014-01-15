class Program < ActiveRecord::Base
  belongs_to :organization

  has_many :program_tags
  has_many :tags, :through => :program_tags


  has_many :program_templates
  has_many :templates, :through => :program_templates


  has_many :program_enrollments
  has_many :users, :through => :program_enrollments


  has_many :program_sessions




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

  def can_delete

    if self.templates and self.templates.size > 0
      #### you will need to remove the member template associations first
      return false
    else

      ### you have no member template associations, BUT
      ### is anyone attached to the program itself?

      if self.users and self.users.size > 0
        ### you would need to first remove the member user associations
        return false
      else

        ### there are no member user associations
        return true
      end
    end
  end ### end def can_delete



  def is_this_user_enrolled(user)
    if self.users.include? user
      return true
    else
      return false
    end
  end

end
