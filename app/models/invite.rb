class Invite < ActiveRecord::Base


  validates_presence_of :from_user_id, :to_name, :to_email, :first_sent_on

  #### had to hack the below together b/c invite.rb for some reason is not able to
  #### see the current_user function from application_controller.rb
  def i_am_owner_or_admin(user_id)
  	user_to_check = User.find(user_id)
  	if user_to_check
  		if user_to_check.is_admin
  			return true
  		else
	  		if self.from_user_id == user_to_check.id
	  			return true
	  		else
	  			return false
	  		end
  		end

  	end

  end ### end def i_am_owner_or_admin(user_id)


  def i_am_recipient(user_id)
    user_to_check = User.find(user_id)
    if user_to_check
      if self.to_user_id and self.to_user_id == user_id
        return true
      else
        if self.to_email and self.to_email == user_to_check.email
          return true
        else
          return false
        end
      end
    end

  end ### end def i_am_recipient(user_id)




end
