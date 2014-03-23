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

  def get_next_listing_position
    highest_listing_position = 0

    self.program_templates.each do |t|
      if t.listing_position and t.listing_position > highest_listing_position
        highest_listing_position = t.listing_position
      end
    end
    return highest_listing_position + 1

  end



  def get_tracks

    we_have_at_least_one_track = false
    arr_tracks = Array.new()
    if self.track_1_name and self.track_1_name != ""
      arr_tracks << [self.track_1_name,1] 
      we_have_at_least_one_track = true
    end
    if self.track_2_name and self.track_2_name != ""
      arr_tracks << [self.track_2_name,2] 
      we_have_at_least_one_track = true
    end
    if self.track_3_name and self.track_3_name != ""
      arr_tracks << [self.track_3_name,3] 
      we_have_at_least_one_track = true
    end
    if self.track_4_name and self.track_4_name != ""
      arr_tracks << [self.track_4_name,4] 
      we_have_at_least_one_track = true
    end
    if self.track_5_name and self.track_5_name != ""
      arr_tracks << [self.track_5_name,5] 
      we_have_at_least_one_track = true
    end
    if self.track_6_name and self.track_6_name != ""
      arr_tracks << [self.track_6_name,6] 
      we_have_at_least_one_track = true
    end
    if self.track_7_name and self.track_7_name != ""
      arr_tracks << [self.track_7_name,7] 
      we_have_at_least_one_track = true
    end
    if self.track_8_name and self.track_8_name != ""
      arr_tracks << [self.track_8_name,8] 
      we_have_at_least_one_track = true
    end
    if self.track_9_name and self.track_9_name != ""
      arr_tracks << [self.track_9_name,9] 
      we_have_at_least_one_track = true
    end
    if self.track_10_name and self.track_10_name != ""
      arr_tracks << [self.track_10_name,10] 
      we_have_at_least_one_track = true
    end

    if !we_have_at_least_one_track
      return false
    else
      return arr_tracks
    end

  end


end
