require 'date'
require 'logger'
class User < ActiveRecord::Base
  belongs_to :bet  
  has_many :bets

  belongs_to :coach
  belongs_to :affiliate
  
  has_many :goals        
  has_many :messages
  
  has_many :organization_users
  has_many :organizations, :through => :organization_users

  ### might not work, will have to test
  belongs_to :template_current_level, :class_name => 'Level', :foreign_key => 'template_current_level_id'

  ### might not work, will have to test
  belongs_to :coach_organization, :class_name => 'Organization', :foreign_key => 'coach_organization_id'


  ### might not work, need to test
  has_many :coach_templates
  has_many :coach_template_goals, :through => :coach_templates

  
  acts_as_authentic
  #acts_as_authentic do |c|
  #  c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  #end # block optional
  validates_presence_of :first_name
  validates_confirmation_of :email
  

  def get_quote_random

      #### Quotes by sponsor as of 20120210
      ## forittobe 	18
      ## habitforge 	58

      random_quote = false
      
      if self.sponsor == "forittobe"
          quote_sponsor = self.sponsor
      else
          quote_sponsor = "habitforge"
      end

        lucky_user_email = ""
        lucky_user_name = ""
        random_user_id = 0

        quotes = Quote.find(:all, :conditions => "sponsor = '#{quote_sponsor}'")
        if quotes.size > 0  
            random_quote_number = rand(quotes.size) + 1 #between 1 and quotes.size
            quote = Quote.find(random_quote_number)
            if quote
                random_quote = quote
            end
        end
        return random_quote
  end

  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end


  def time_hour_right_now
      tnow = Time.new()
      
      Time.zone = self.time_zone
      if Time.zone != nil
          tnow = Time.zone.now
      else
          tnow = Time.now 
      end

    tnow_k = tnow.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
  end
  
  def time_period_of_day_right_now
      period = "day"
      if self.time_hour_right_now < 12
        return "morning"
      end
      if self.time_hour_right_now >= 12 and self.time_hour_right_now < 17
        return "afternoon"
      end
      if self.time_hour_right_now >= 17 and self.time_hour_right_now <= 23
        return "evening"
      end
      return period
  end
  
  def dtoday
      jump_forward_seconds = 0
      jump_forward_days = 0
      
      tnow = Time.new()
      Time.zone = self.time_zone
      if Time.zone != nil
          tnow = Time.zone.now + jump_forward_seconds #User time
      else
          tnow = Time.now + jump_forward_seconds 
      end

      tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
      tnow_m = tnow.strftime("%m").to_i #month of the year
      tnow_d = tnow.strftime("%d").to_i #day of the month
      tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
      tnow_k = tnow.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
      tnow_M = tnow.strftime("%M").to_i #minute of the hour
      #puts tnow_Y + tnow_m + tnow_d  
      #puts "Current timestamp is #{tnow.to_s}"
      dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
      
      return dnow      
  end

  def dyesterday
      return self.dtoday - 1
  end

  def dtomorrow
      return self.dtoday + 1
  end


  def when_was_last_week_monday
    dnow = self.dtoday
      
    ###Calculate number of "yes" answers from last Monday through Sunday
    dlastmonday = dnow - 7

    dnow_minus_8 = dnow - 8
    dnow_minus_9 = dnow - 9
    dnow_minus_10 = dnow - 10
    dnow_minus_11 = dnow - 11
    dnow_minus_12 = dnow - 12
    dnow_minus_13 = dnow - 13

    dlastweek_dayname = dlastmonday.strftime("%A")
    dnow_minus_8_dayname = dnow_minus_8.strftime("%A")
    dnow_minus_9_dayname = dnow_minus_9.strftime("%A")
    dnow_minus_10_dayname = dnow_minus_10.strftime("%A")
    dnow_minus_11_dayname = dnow_minus_11.strftime("%A")
    dnow_minus_12_dayname = dnow_minus_12.strftime("%A")
    dnow_minus_13_dayname = dnow_minus_13.strftime("%A")

    if dlastweek_dayname == "Monday"
        dlastmonday = dlastmonday
    end
    if dnow_minus_8_dayname == "Monday"
        dlastmonday = dnow_minus_8
    end
    if dnow_minus_9_dayname == "Monday"
        dlastmonday = dnow_minus_9
    end
    if dnow_minus_10_dayname == "Monday"
        dlastmonday = dnow_minus_10
    end
    if dnow_minus_11_dayname == "Monday"
        dlastmonday = dnow_minus_11
    end
    if dnow_minus_12_dayname == "Monday"
        dlastmonday = dnow_minus_12
    end
    if dnow_minus_13_dayname == "Monday"
        dlastmonday = dnow_minus_13
    end
    return dlastmonday
  end
  
  def when_was_this_week_monday

    dnow = self.dtoday

    dmonday = dnow

    dnow_minus_1 = dnow - 1
    dnow_minus_2 = dnow - 2
    dnow_minus_3 = dnow - 3
    dnow_minus_4 = dnow - 4
    dnow_minus_5 = dnow - 5
    dnow_minus_6 = dnow - 6

    dnow_dayname = dnow.strftime("%A")
    dnow_minus_1_dayname = dnow_minus_1.strftime("%A")
    dnow_minus_2_dayname = dnow_minus_2.strftime("%A")
    dnow_minus_3_dayname = dnow_minus_3.strftime("%A")
    dnow_minus_4_dayname = dnow_minus_4.strftime("%A")
    dnow_minus_5_dayname = dnow_minus_5.strftime("%A")
    dnow_minus_6_dayname = dnow_minus_6.strftime("%A")

    if dnow_dayname == "Monday"
        dmonday = dnow
    end
    if dnow_minus_1_dayname == "Monday"
        dmonday = dnow_minus_1
    end
    if dnow_minus_2_dayname == "Monday"
        dmonday = dnow_minus_2
    end
    if dnow_minus_3_dayname == "Monday"
        dmonday = dnow_minus_3
    end
    if dnow_minus_4_dayname == "Monday"
        dmonday = dnow_minus_4
    end
    if dnow_minus_5_dayname == "Monday"
        dmonday = dnow_minus_5
    end
    if dnow_minus_6_dayname == "Monday"
        dmonday = dnow_minus_6
    end
    return dmonday
  end

  def when_was_last_week_sunday
      dnow = self.dtoday
      
    ###Calculate number of "yes" answers from last Monday through Sunday

    ###############################
    dlastsunday = dnow - 1

    dnow_minus_2 = dnow - 2
    dnow_minus_3 = dnow - 3
    dnow_minus_4 = dnow - 4
    dnow_minus_5 = dnow - 5
    dnow_minus_6 = dnow - 6
    dnow_minus_7 = dnow - 7

    dlastsunday_dayname = dlastsunday.strftime("%A")
    dnow_minus_2_dayname = dnow_minus_2.strftime("%A")
    dnow_minus_3_dayname = dnow_minus_3.strftime("%A")
    dnow_minus_4_dayname = dnow_minus_4.strftime("%A")
    dnow_minus_5_dayname = dnow_minus_5.strftime("%A")
    dnow_minus_6_dayname = dnow_minus_6.strftime("%A")
    dnow_minus_7_dayname = dnow_minus_7.strftime("%A")

    if dlastsunday_dayname == "Sunday"
        dlastsunday = dlastsunday
    end
    if dnow_minus_2_dayname == "Sunday"
        dlastsunday = dnow_minus_2
    end
    if dnow_minus_3_dayname == "Sunday"
        dlastsunday = dnow_minus_3
    end
    if dnow_minus_4_dayname == "Sunday"
        dlastsunday = dnow_minus_4
    end
    if dnow_minus_5_dayname == "Sunday"
        dlastsunday = dnow_minus_5
    end
    if dnow_minus_6_dayname == "Sunday"
        dlastsunday = dnow_minus_6
    end
    if dnow_minus_7_dayname == "Sunday"
        dlastsunday = dnow_minus_7
    end            

      return dlastsunday
  end


  def can_use_templates
    case self.email
    when "jurowski2@gmail.com"
      return true
    when "jurowski@gmail.com"
      return true
    else
      return false
    end
  end

  def can_make_templates
    case self.email
    when "jurowski2@gmail.com"
      return true
    when "jurowski@gmail.com"
      return true
    else
      return false
    end
  end

  def templates_i_own
      my_goals = Array.new()
      for goal in all_goals
          if goal.template_owner_is_a_template
              my_goals << goal
          end
      end
      return my_goals
  end

  def number_of_templates_i_own
      size = 0
      if self.templates_i_own
          size = self.templates_i_own.size
      end
      return size
  end 


  def hold_goals
      my_goals = Array.new()
      for goal in all_goals
          if goal.status == 'hold' and !goal.template_owner_is_a_template
              my_goals << goal
          end
      end
      return my_goals
  end
  def stale_goals
      my_goals = Array.new()
      for goal in all_goals
          if !goal.is_active and goal.status != 'hold'
              my_goals << goal
          end
      end
      return my_goals
  end
  def active_goals
      my_goals = Array.new()
      for goal in all_goals
          if goal.is_active
              my_goals << goal
          end
      end
      return my_goals
  end

  def active_public_goals
      my_goals = Array.new()
      for goal in all_goals
          if goal.is_active_and_public
              my_goals << goal
          end
      end
      return my_goals
  end

  def number_of_active_public_habits
      size = 0
      if self.active_public_goals
          size = self.active_public_goals.size
      end
      return size
  end

  def all_goals
      my_goals = Goal.find(:all, :conditions => "user_id = '#{self.id}'")
  end

  def number_of_active_habits
      size = 0
      if self.active_goals
          size = self.active_goals.size
      end
      return size
  end
  def number_of_stale_habits
      size = 0
      if self.stale_goals
          size = self.stale_goals.size
      end
      return size
  end  
  def number_of_hold_habits
      size = 0
      if self.hold_goals
          size = self.hold_goals.size
      end
      return size
  end 





  def dstop_after_stale_days
      dstop_after = dtoday - 15
  end
  
  def active_start_goals
      #my_start_goals = Goal.find(:all, :conditions => "user_id = '#{self.id}' and status = 'start' and established_on = '1900-01-01'")   
      #my_start_goals = Goal.find(:all, :conditions => "user_id = '#{self.id}' and status = 'start' and ((start <= #{self.dtomorrow} and stop >= #{self.dtoday}) or (laststatusdate is not null and laststatusdate > #{self.dstop_after_stale_days}))")
      my_goals = Array.new()
      for goal in all_goals
          if goal.is_active and goal.status == 'start'
              my_goals << goal
          end
      end
      return my_goals
  end
  def active_monitor_goals
      #my_monitor_goals = Goal.find(:all, :conditions => "user_id = '#{self.id}' and status = 'monitor'") 
      #my_monitor_goals = Goal.find(:all, :conditions => "user_id = '#{self.id}' and status = 'monitor' and ((start <= #{self.dtomorrow} and stop >= #{self.dtoday}) or (laststatusdate is not null and laststatusdate > #{self.dstop_after_stale_days}))")
      my_goals = Array.new()
      for goal in all_goals
          if goal.is_active and goal.status == 'monitor'
              my_goals << goal
          end
      end
      return my_goals
  end


  def active_goals_sorted_by_next_action_day
    my_goals = Array.new()
    if self.active_goals
        my_goals = self.active_goals
        my_goals.sort! {|a,b| a.date_next_to_take_action <=> b.date_next_to_take_action}
    end
    return my_goals
  end

  #### NOTE THAT THIS ONE CARES ABOUT "NEXT ACTION DATE"
  #### SO IT IGNORES ANY THAT WOULD HAVE ALREADY BEEN WORKED ON
  #### SO DON'T REFERENCE IT IN AUTOUPDATEMULTIPLE
  def next_goals_working_on_for_date(action_date)
      my_goals = Array.new()
      for goal in self.active_goals
          if goal.is_this_a_relevant_day(action_date)
            if goal.date_next_to_take_action == action_date
              my_goals << goal
            end
          end 
      end
      return my_goals
  end
  def number_next_goals_working_on_for_date(action_date)
      size = 0
      if next_goals_working_on_for_date(action_date).size > 0
          size = next_goals_working_on_for_date(action_date).size
      end
      return size
  end


  #### YOU CAN REFERENCE THIS IN AUTOUPDATEMULTIPLE
  def all_goals_working_on_for_date(action_date)
      my_goals = Array.new()
      for goal in self.active_goals
          if goal.is_this_a_relevant_day(action_date)
              my_goals << goal
          end 
      end
      return my_goals
  end
  def number_all_goals_working_on_for_date(action_date)
      size = 0
      if all_goals_working_on_for_date(action_date).size > 0
          size = all_goals_working_on_for_date(action_date).size
      end
      return size
  end

  def goals_unsuccessful_on_date(action_date)
      my_goals = Array.new()
      for goal in self.all_goals_working_on_for_date(action_date)
          if goal.get_daily_status_for(action_date) == "no"
              my_goals << goal
          end 
      end
      return my_goals
  end

  def goals_unsuccessful_needing_personal_motivator_on_date(action_date)
      my_goals = Array.new()
      for goal in self.goals_unsuccessful_on_date(action_date)
          if goal.pp_remind == true
              ### Decide whether it's time to insert the reminder 
              doit = false
              if goal.pp_remind_last_date == nil
            	doit = true
              else
            	dnextreminder = goal.pp_remind_last_date + 3
            	if goal.user.dtoday == dnextreminder or goal.user.dtoday > dnextreminder
            		doit = true
            	end
              end
              if doit
                  my_goals << goal
              end 
          end
      end
      return my_goals  
  end




  def is_habitforge_supporting_member
      ### things are a little messed up w/ clearworth
      if (self.sponsor == "habitforge" or self.sponsor == "clearworth") and self.kill_ads_until != nil and self.kill_ads_until >= self.dtoday
          return true
      else
          return false
      end
  end
  
end
