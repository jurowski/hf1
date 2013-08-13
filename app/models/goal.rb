require 'logger'
require 'date'
class Goal < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  belongs_to :bet
  belongs_to :coachgoal
  belongs_to :goaltemplate

  has_many :checkpoints
  has_many :expiredcheckpoints
  has_many :cheers                 

  has_many :goaltags
  has_many :tags, :through => :goaltags

  has_many :level_goals
  has_many :levels, :through => :level_goals


  ### might not work, need to test
  has_many :coach_templates
  has_many :coach_users, :through => :coach_templates




  ### might not work, will have to test
  has_many :triggers

  ### might not work, will have to test
  belongs_to :template_user_parent_goal, :class_name => 'Goal', :foreign_key => 'template_user_parent_goal_id'  

  ### might not work, will have to test
  belongs_to :template_current_level, :class_name => 'Level', :foreign_key => 'template_current_level_id'

  ### might not work, will have to test
  belongs_to :template_next_template_goal, :class_name => 'Goal', :foreign_key => 'template_next_template_goal_id'

  belongs_to :program, :class_name => 'Program', :foreign_key => 'goal_added_through_template_from_program_id'


  has_many :message_goals
  has_many :messages, :through => :message_goals

  attr_accessor :number_invites_sent_to_followers, :invites_sent_to_followers, :number_of_checkpoints_missing_after_start_date, :checkpoints_missing_after_start_date, :date_next_to_take_action, :has_unanswered_checkpoints, :days_to_form_a_habit, :successful_days_in_a_row, :number_of_checkpoints_with_answer_of_no, :number_of_checkpoints_with_answer_of_yes, :percent_of_checkpoints_with_answer_of_no, :percent_of_checkpoints_with_answer_of_yes, :number_of_checkpoints, :days_left_until_habit_is_formed, :get_dnow, :get_quote_random

  validates_presence_of :response_question

  ### for now, allowing duplicates in case user creates a template and then adopts it
  #validates_uniqueness_of :response_question, :scope => :user_id

  validate :deny_hackers
  def deny_hackers
    errors.add(:pleasure, "Sorry, for security reasons we can not allow links to be added to text fields.") if(pleasure and pleasure.include? "http:")
    errors.add(:pain, "Sorry, for security reasons we can not allow links to be added to text fields.") if(pain and pain.include? "http:") 
    errors.add(:response_question, "Sorry, for security reasons we can not allow links to be added to text fields.") if(response_question and response_question.include? "http:") 	
  end 

  def copy_goal_to_template_and_make_template_parent

  end

  def is_future
    if self.status != "hold" and self.start > self.user.dtoday
        return true
    else
        return false
    end
  end

  def is_active_and_public
    if self.is_active and self.is_public
        return true
    else
        return false
    end
  end

  def is_public
    if self.publish
        return true
    else
        return false
    end
  end
  
  def is_active
    #### the rules used by the cron checkpoint creation script:
    #### goal_conditions = goal_conditions + " and status != 'hold'"
    #### goal_conditions = goal_conditions + " and ((start < '#{dnow}' and stop >= '#{dnow}') or (laststatusdate is not null and laststatusdate > '#{user.dstop_after_stale_days}'))"
    if self.status != "hold" and (((self.start != nil  and (self.start <= self.user.dtomorrow)) and (self.stop != nil and (self.stop >= self.user.dtoday))) or ((self.laststatusdate != nil) and (self.laststatusdate > self.user.dstop_after_stale_days)))
        return true        
    else
        return false
    end
  end

  def every_day
      if self.daym and self.dayt and self.dayw and self.dayr and self.dayf and self.days and self.dayn
          return true
      else
          return false
      end
  end  



  def get_quote_random

      random_quote = false

      some_conditions = ""
      if self.category != nil and self.category != ""
        some_conditions = "category = '#{self.category}'"
      else
        quote_sponsor = "habitforge"
        if self.user.sponsor == "forittobe"
            quote_sponsor = self.user.sponsor
        end
        some_conditions = "sponsor = '#{quote_sponsor}' and category is null"
      end



      quotes = Quote.find(:all, :conditions => some_conditions)


      if quotes.size > 0  
          random_quote_number = rand(quotes.size) #between 0 and quotes.size
          quote = quotes[random_quote_number]
          if quote
              random_quote = quote
          end
      else

        ### there are not any quotes yet for that category, so grab a random one
        quote_sponsor = "habitforge"
        if self.user.sponsor == "forittobe"
            quote_sponsor = self.user.sponsor
        end
        some_conditions = "sponsor = '#{quote_sponsor}' and category is null"
        quotes = Quote.find(:all, :conditions => some_conditions)
        if quotes.size > 0  
            random_quote_number = rand(quotes.size) #between 0 and quotes.size
            quote = quotes[random_quote_number]
            if quote
                random_quote = quote
            end
        end
      end

      return random_quote

  end


  def date_created
      tcreated = self.created_at

      tcreated_Y = tcreated.strftime("%Y").to_i #year, 4 digits
      tcreated_m = tcreated.strftime("%m").to_i #month of the year
      tcreated_d = tcreated.strftime("%d").to_i #day of the month
      tcreated_H = tcreated.strftime("%H").to_i #hour (24-hour format)
      tcreated_k = tcreated.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
      tcreated_M = tcreated.strftime("%M").to_i #minute of the hour
      #puts tcreated_Y + tcreated_m + tcreated_d  
      #puts "Current timestamp is #{tcreated.to_s}"
      dcreated = Date.new(tcreated_Y, tcreated_m, tcreated_d)
      return dcreated      
  end

  def get_day_of_week_short_name(date_incoming)
      day_of_week = date_incoming.strftime("%A")

      if day_of_week == "Monday"
          return "daym"
      end
      if day_of_week == "Tuesday"
          return "dayt"
      end
      if day_of_week == "Wednesday"
          return "dayw"
      end
      if day_of_week == "Thursday"
          return "dayr"
      end
      if day_of_week == "Friday"
          return "dayf"
      end
      if day_of_week == "Saturday"
          return "days"
      end
      if day_of_week == "Sunday"
          return "dayn"
      end
  end
  
  def date_next_to_take_action
      ### The next day that you'll be taking action on your goal
      ### (start date or today or later depending on valid days of the week)

      next_action_date = self.start
      if self.user.dtoday > next_action_date
        next_action_date = self.user.dtoday        
      end

      ### IF they already failed today, push next action day to tomorrow
      if next_action_date == self.user.dtoday
        if (self.get_daily_status_for(next_action_date) == "yes" or self.get_daily_status_for(next_action_date) == "no")
          next_action_date = next_action_date + 1
        end
      end        

      next_action_date_dayname = get_day_of_week_short_name(next_action_date)
      
      #logger.debug "SGJ:goal.model daym = " + self.daym.to_s
      #logger.debug "SGJ:goal.model dayt = " + self.dayt.to_s
      #logger.debug "SGJ:goal.model dayw = " + self.dayw.to_s
      #logger.debug "SGJ:goal.model dayr = " + self.dayr.to_s
      #logger.debug "SGJ:goal.model dayf = " + self.dayf.to_s
      #logger.debug "SGJ:goal.model days = " + self.days.to_s
      #logger.debug "SGJ:goal.model dayn = " + self.dayn.to_s

      6.times do
          if next_action_date_dayname == "daym"
            if self.daym
                return next_action_date
            end
          end
          if next_action_date_dayname == "dayt"
            if self.dayt
                return next_action_date
            end
          end
          if next_action_date_dayname == "dayw"
            if self.dayw
                return next_action_date
            end
          end
          if next_action_date_dayname == "dayr"
            if self.dayr
                return next_action_date
            end
          end
          if next_action_date_dayname == "dayf"
            if self.dayf
                return next_action_date
            end
          end
          if next_action_date_dayname == "days"
            if self.days
                return next_action_date
            end
          end
          if next_action_date_dayname == "dayn"
            if self.dayn
                return next_action_date
            end
          end

          next_action_date = next_action_date + 1
          next_action_date_dayname = get_day_of_week_short_name(next_action_date)
          #logger.debug next_action_date_dayname
          
      end

      return next_action_date
      #return self.user.dtoday
  end
  
  def date_next_checkin_email_will_be_sent
      return self.date_next_to_take_action + 1
  end
  
  
  def restart_my_goal_at_day_1
      success = true
      begin
        self.start = self.user.dtoday
        self.stop = self.start + self.days_to_form_a_habit
        self.daysstraight = 0
        self.save

        ### update last activity date
        self.user.last_activity_date = self.user.dtoday
        self.user.save

      rescue
          success = false
          logger.error "SGJ failed to restart goal"
      end
      return success
  end
  
  def checkpoints
    goal_checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}'")
  end  

  def checkpoints_asc
    goal_checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}'", :order => "checkin_date asc")
  end  

  
  ### note that the db is storing "daysintoit" or "days_into_it" but that's a
  ### count of how many checkpoints there are, not how many days since the first checkpoint
  ### so if not all days of the week are relevant, the number is off
  def days_since_first_checkpoint
      days_since = 0
      if self.date_of_first_checkpoint
        days_since = self.user.dtoday - self.date_of_first_checkpoint
      end
      return days_since
  end
  def date_of_first_checkpoint
      first_checkpoint = Checkpoint.find(:first, :conditions => "goal_id = '#{self.id}'", :order => "checkin_date ASC")
      if first_checkpoint
        return first_checkpoint.checkin_date
      else
        return false
      end
  end

  def number_of_checkpoints
    count_checkpoints = 0
    if self.checkpoints.size != nil
        count_checkpoints = self.checkpoints.size

        ### Do not include today unless today is already a "yes" or a "no"
        today_checkpoint = Checkpoint.find(:first, :conditions => "goal_id = '#{self.id}' and checkin_date = '#{self.user.dtoday}' and status != 'yes' and status != 'no'")
        if today_checkpoint
            count_checkpoints = count_checkpoints - 1 
        end

    end      
    return count_checkpoints
  end
  
  def number_of_checkpoints_with_answer_of_no
      count_checkpoints_with_answer_of_no = 0

      no = Checkpoint.find(:all, :conditions => "status = 'no' and goal_id = '#{self.id}'")
      if no.size != nil
          count_checkpoints_with_answer_of_no = no.size
      end
      return count_checkpoints_with_answer_of_no
  end

  def number_of_checkpoints_with_answer_of_yes
      count_checkpoints_with_answer_of_yes = 0

      yes = Checkpoint.find(:all, :conditions => "status = 'yes' and goal_id = '#{self.id}'")
      if yes.size != nil
          count_checkpoints_with_answer_of_yes = yes.size
      end
      return count_checkpoints_with_answer_of_yes
  end
  
  def percent_of_checkpoints_with_answer_of_no
    percent_no = 0
    if self.number_of_checkpoints > 0
        percent_no = (((self.number_of_checkpoints_with_answer_of_no + 0.0) / self.number_of_checkpoints)*100).floor
    end
    return percent_no
  end

  ### success rate relative to days per week goal
  def percent_of_checkpoints_with_answer_of_yes(calc_for_all_time = false)
    percent_yes = 0

    #if self.number_of_checkpoints > 0
    if self.days_since_first_checkpoint > 0

        ##percent_yes = (((self.number_of_checkpoints_with_answer_of_yes + 0.0) / self.number_of_checkpoints)*100).floor
        #percent_yes = (((self.number_of_checkpoints_with_answer_of_yes + 0.0) / self.days_since_first_checkpoint)*100).floor

            #### SUCCESSS RATES ARE NOW LAGGING RATES
            #### (it is baked into def success_rate_during_past_n_days )

          if calc_for_all_time
            percent_yes = self.success_rate_during_past_n_days(self.days_since_first_checkpoint)
          else

            got_one = false
            age_counter = 30
            while age_counter > 0
                if !got_one and self.days_since_first_checkpoint >= age_counter
                      #logger.debug("sgj: age_counter= " + age_counter.to_s)
                      percent_yes = self.success_rate_during_past_n_days(age_counter)
                      #logger.debug("sgj: percent_yes = " + percent_yes.to_s)
                      got_one = true
                end
                age_counter = age_counter - 1
            end

          end

    end





    ### relative already baked into success_rate_during_past_n_days
    #relative_success_rate = (((percent_yes + 0.0) / self.desired_success_rate)*100).floor
    #if relative_success_rate > 100
    #  relative_success_rate = 100
    #end
    #logger.info("sgj:percent_yes = " + percent_yes.to_s + " and relative_success_rate = " + relative_success_rate.to_s)

    return percent_yes
    #return relative_success_rate
  end

  

  def get_goal_days_per_week
      if self.goal_days_per_week == nil
          return 7
      else
          return self.goal_days_per_week
      end
  end
  
  def desired_success_rate
      desired = ((self.get_goal_days_per_week * 100)/ 7)
  end

  def forged_in
      if self.established_on.to_s != "1900-01-01"
	  if self.established_on and self.date_of_first_checkpoint
            number_of_days_to_forge = self.established_on - self.date_of_first_checkpoint
            return number_of_days_to_forge 
          else
	    return false
	  end
      else
          return false
      end
  end
  
  def days_left_until_habit_is_formed
    days_left = self.days_to_form_a_habit - self.successful_days_in_a_row_without_9s
    
    #days_left = 0
    #
    #### FOR HABIT.START GOALS ONLY!!! WILL NOT WORK IF SKIPPING ANY DAYS!!!
    #### instead of daysgoneby = dnow - goal.start,
    #### calculate, instead the number of checkpoints that have been created
    #### ... but yeah, that will only work for goals that are "ever day !!!"
    #checkpoints_gone_by = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date >= '#{self.start}'")
    #daysgoneby = 0
    #if checkpoints_gone_by.size != nil
    #    daysgoneby = checkpoints_gone_by.size
    #end
    #days_left = self.days_to_form_a_habit - daysgoneby
    #
    #return days_left
  end
  
  def days_to_form_a_habit
      return 21
  end
  
  def successful_days_in_a_row

    ### expensive, but no bad caching behavior (see below) 
    days_in_a_row = self.update_daysstraight

    #days_in_a_row = 0
    #if self.daysstraight != nil
    #  days_in_a_row = self.daysstraight
    #end
    return days_in_a_row
  end

  def successful_days_in_a_row_without_9s
    #days_in_a_row = 0
   
    ### expensive, but no bad caching behavior (see below) 
    days_in_a_row = self.update_daysstraight
    if days_in_a_row == 9999
        return 0
    else
        return days_in_a_row
    end
    
    #if self.daysstraight != nil and self.daysstraight != 9999
    #  ### pulling this # from the db was causing odd caching behavior,
    #  ### where it would not pull the latest db value but instead the
    #  ### previous value
    #  #days_in_a_row = self.daysstraight
    #end
    #return days_in_a_row
  end

  
  def update_longest_run
    longestrun = 0
    if successful_days_in_a_row > 0 and successful_days_in_a_row < 9999
        if self.longestrun == nil
            longestrun = successful_days_in_a_row
              self.longestrun = longestrun
              self.save      
        else
            if successful_days_in_a_row > self.longestrun
              longestrun = successful_days_in_a_row
              self.longestrun = longestrun
              self.save      
            end    
        end
    end
    

    return self.longestrun
  end

  def get_longest_run
    longestrun = 0
    if self.longestrun != nil
      longestrun = self.longestrun
    end
    return longestrun
  end

  def update_daysstraight

    #############################################################
    ###### DETERMINE DAYS STRAIGHT                       ########
    #############################################################
    daysstraight = 0
    keep_going = "yes"
    checkpoints = Array.new()
    checkpoints_non_yes = Array.new()
    ### count backward from the most recent checkpoints

    ### Do not include today unless today is already a "yes" or a "no"
    today_checkpoint = Checkpoint.find(:first, :conditions => "goal_id = '#{self.id}' and checkin_date = '#{self.user.dtoday}' and (status = 'yes' or status = 'no')")
    if today_checkpoint
        checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}'", :order =>  "checkin_date desc")
    else
        checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date != '#{self.user.dtoday}'", :order =>  "checkin_date desc")
    end

    for checkpoint in checkpoints
      if keep_going == "yes"
        if checkpoint.status == "yes"
          daysstraight = daysstraight + 1
        else
          keep_going = "no"
        end
      end
    end 


    if today_checkpoint
        checkpoints_non_yes = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date >= '#{self.start}' and status <> 'yes'")
    else
        checkpoints_non_yes = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date >= '#{self.start}' and status <> 'yes' and checkin_date != '#{self.user.dtoday}'")
    end


    if checkpoints_non_yes != nil
      if checkpoints_non_yes.size > 0
        ### have some unanswered checkpoints, but we only care if goal.status == 'start'
        if self.status == "start"
          daysstraight = 9999
        end
      end
    end
    self.daysstraight = daysstraight
    self.save
    #############################################################
    ###### END DETERMINE DAYS STRAIGHT                   ########
    #############################################################

    return daysstraight
  end
  
  def checkpoints_missing_after_start_date
    checkpoints_missing = Checkpoint.find(:all, :conditions => "(status != 'yes' and status != 'no') and goal_id = '#{self.id}' and checkin_date >= '#{self.start}' and checkin_date < '#{self.user.dtoday}'", :order => "checkin_date DESC")
  end
  
  def has_unanswered_checkpoints
    missing = false    
    if checkpoints_missing_after_start_date != nil and checkpoints_missing_after_start_date.size > 0
        missing = true
    end
    return missing
  end

  def number_of_checkpoints_missing_after_start_date
      size = 0
      if self.has_unanswered_checkpoints
          size = self.checkpoints_missing_after_start_date.size
      end
      return size
  end

  
  def stats_image_small(width)
      image = ""

        if self.has_unanswered_checkpoints
          image << '<img src="/images/question.png" alt="Missing checkpoints" width=' + width.to_s + 'px border="0"/>'
        else
            if self.forged_in
                image << '<img src="/images/ring_buttons21_100w.png" alt="Established Habit" width=' + width.to_s + 'px border=0/>'
            else
                if self.status == 'start'
                    image << '<img src="/images/ring_buttons' + self.successful_days_in_a_row_without_9s.to_s + '_100w.png" alt="" width=' + width.to_s + 'px border="0"/>'
                end
            end
        end

      return image
  end

  def stats_image
      image = ""
      width = 100

        if self.has_unanswered_checkpoints
          ### used to click to: <a href="goals/single/' + self.id.to_s + '">
          image << '<a href="/goals#jump_to_catchup_on_goal_id_' + self.id.to_s + '" class="btn red"><i class="icon-warning-sign"></i> Catch up to see full stats.</a></strong></br>'
        else
            if self.forged_in
              image << '<img src="/images/ring_buttons21_100w.png" alt="Established Habit" width=' + width.to_s + 'px border=0/>'
            else
                if self.status == 'start'
                    image << '<img src="/images/ring_buttons' + self.successful_days_in_a_row_without_9s.to_s + '_100w.png" alt="" width=' + width.to_s + 'px border="0"/>'
                end
            end
        end
      return image
  end
  
  def stats_output
      output = ""
      save_here_because_found_difference = false
      show_longest_run_disclaimer = false
        if self.number_of_checkpoints > 0
          if !self.has_unanswered_checkpoints
            output << "<h3>"
            if self.successful_days_in_a_row > 1 and self.successful_days_in_a_row != 9999 
                output << self.successful_days_in_a_row.to_s + " days straight...<br>"

                if self.longestrun != nil and self.longestrun > 2
                    if self.daysstraight == self.longestrun
                      output << " your longest run yet! <br>"
                    else
                      output << " <font style='font-size:80%;'>(Your longest run so far is #{self.longestrun})</font><br>"
                    end
                    #output << "<h5>*(Longest run since we started tracking that stat on Jan. 27, 2012)</h5"
                end
            end

            if self.status == "start" and !self.forged_in
                output << self.days_left_until_habit_is_formed.to_s + " left to go!"
            end

            if self.forged_in and ( self.forged_in >= self.days_to_form_a_habit )
                if self.forged_in > (self.days_to_form_a_habit + 20 )
                    output << "This habit was 'forged' (#{self.days_to_form_a_habit} days straight)... it took #{self.forged_in} days, but you did it!"
                else
                    output << "This habit was 'forged' (#{self.days_to_form_a_habit} days straight)... after just #{self.forged_in} days!"
                end
            end


            if self.status == "monitor"
                output << "<br>"
                output << this_week_results
                output << "<br>"
                output << last_week_results
            end
            

            output << "</h3>"  
            output << "<p>"
            #output << ".: " + self.percent_of_checkpoints_with_answer_of_yes.to_s + "% Overall Success Rate"

              if self.days_since_first_checkpoint > 7
                 output << " .: " + self.success_rate_during_past_n_days(self.days_since_first_checkpoint).to_s + "% Overall :."
              end


           past_n_days = 7
           if self.days_since_first_checkpoint >= past_n_days
              success_rate_n = self.success_rate_during_past_n_days(past_n_days)
              output << " .: " + success_rate_n.to_s + "% during last #{past_n_days} days :."

              if self.success_rate_during_past_7_days == nil or (self.success_rate_during_past_7_days != success_rate_n)
                self.success_rate_during_past_7_days = success_rate_n
                save_here_because_found_difference = true
              end

           end

           past_n_days = 21
           if self.days_since_first_checkpoint >= past_n_days
              success_rate_n = self.success_rate_during_past_n_days(past_n_days)
              output << " .: " + success_rate_n.to_s + "% during last #{past_n_days} days :."

              if self.success_rate_during_past_21_days == nil or (self.success_rate_during_past_21_days != success_rate_n)
                self.success_rate_during_past_21_days = success_rate_n
                save_here_because_found_difference = true
              end


           end

           past_n_days = 30
           if self.days_since_first_checkpoint >= past_n_days
              success_rate_n = self.success_rate_during_past_n_days(past_n_days)
              output << " .: " + success_rate_n.to_s + "% during last #{past_n_days} days :."

              if self.success_rate_during_past_30_days == nil or (self.success_rate_during_past_30_days != success_rate_n)
                self.success_rate_during_past_30_days = success_rate_n
                save_here_because_found_difference = true
              end


           end

           ### not going to write the 14-day and others to output since it gets too long
           ### but do save it in the db
           past_n_days = 14
           if self.days_since_first_checkpoint >= past_n_days
              success_rate_n = self.success_rate_during_past_n_days(past_n_days)

              if self.success_rate_during_past_14_days == nil or (self.success_rate_during_past_14_days != success_rate_n)
                self.success_rate_during_past_14_days = success_rate_n
                save_here_because_found_difference = true
              end

           end


           past_n_days = 60
           if self.days_since_first_checkpoint >= past_n_days
              success_rate_n = self.success_rate_during_past_n_days(past_n_days)

              if self.success_rate_during_past_60_days == nil or (self.success_rate_during_past_60_days != success_rate_n)
                self.success_rate_during_past_60_days = success_rate_n
                save_here_because_found_difference = true
              end

           end

           past_n_days = 90
           if self.days_since_first_checkpoint >= past_n_days
              success_rate_n = self.success_rate_during_past_n_days(past_n_days)

              if self.success_rate_during_past_90_days == nil or (self.success_rate_during_past_90_days != success_rate_n)
                self.success_rate_during_past_90_days = success_rate_n
                save_here_because_found_difference = true
              end

           end

           past_n_days = 180
           if self.days_since_first_checkpoint >= past_n_days
              success_rate_n = self.success_rate_during_past_n_days(past_n_days)

              if self.success_rate_during_past_180_days == nil or (self.success_rate_during_past_180_days != success_rate_n)
                self.success_rate_during_past_180_days = success_rate_n
                save_here_because_found_difference = true
              end

           end

           past_n_days = 270
           if self.days_since_first_checkpoint >= past_n_days
              success_rate_n = self.success_rate_during_past_n_days(past_n_days)

              if self.success_rate_during_past_270_days == nil or (self.success_rate_during_past_270_days != success_rate_n)
                self.success_rate_during_past_270_days = success_rate_n
                save_here_because_found_difference = true
              end

           end

           past_n_days = 365
           if self.days_since_first_checkpoint >= past_n_days
              success_rate_n = self.success_rate_during_past_n_days(past_n_days)

              if self.success_rate_during_past_365_days == nil or (self.success_rate_during_past_365_days != success_rate_n)
                self.success_rate_during_past_365_days = success_rate_n
                save_here_because_found_difference = true
              end

           end








            # how_long = Array.new()
            # how_long = [7, 21, 30]
            # for age in how_long
            #    if self.days_since_first_checkpoint >= age
            #       output << " .: " + self.success_rate_during_past_n_days(age).to_s + "% during last #{age} days :."
            #    end
            # end    

            #output << " :."        
            #if self.last_stats_badge_date != nil
            #    #output << "<h5>last tallied #{self.last_stats_badge_date}</h5>"
            #end

            if self.desired_success_rate < 100
              output << " <br>(Success rates pro-rated relative to your goal of " + self.get_goal_days_per_week.to_s + " days per week)"
            end

            output << "</p>"
          end 
        end 

      if save_here_because_found_difference
        self.save
      end

      return output
  end

  def status_phrase(reporting_date)

    ########################################
    ###### PRINT FRIENDLY STATUS PHRASE ####
    ########################################

    phrase = ""
    
    if self.get_daily_status_for(reporting_date) == "yes"
        arr_congrats = Array.new
        arr_congrats.push(["Keep up the good work with xxx, #{self.user.first_name}! The more you succeed, the easier it becomes!"])
        arr_congrats.push(["Hey, you kept your word about xxx! Good job #{self.user.first_name}!"])
        arr_congrats.push(["Winning is pretty cool, isn't it #{self.user.first_name}? Keep up the great work with your xxx goal!"])
        arr_congrats.push(["Kudos to you for following through with your xxx goal, #{self.user.first_name}!"])
        arr_congrats.push(["So, #{self.user.first_name}...How's it feel to put a notch in the success column? You achieved your xxx goal!"])
        arr_congrats.push(["Hey, great job with your xxx goal, #{self.user.first_name}!"])
        arr_congrats.push(["You did it, #{self.user.first_name}! Nice job with xxx !"])
        arr_congrats.push(["Alright #{self.user.first_name}! A successful day! Keep up the good work with your daily goal of xxx !"])

        random_number = 0
        random_number = rand(arr_congrats.size) + 0 #between 0 and arr_congrats.size
        random_congrats = arr_congrats[random_number]
        phrase = random_congrats.to_s
        phrase = phrase.sub("xxx","''" + self.title + "''")
    end
    if self.get_daily_status_for(reporting_date) == "no"
        arr_sorry = Array.new
        arr_sorry.push(["Hi #{self.user.first_name}. Sorry you weren't successful at your xxx goal."])



        if self.get_goal_days_per_week == 7
          arr_sorry.push(["Hi #{self.user.first_name}. Sorry you weren't successful at your xxx goal."])
          arr_sorry.push(["Ok. Hey, every day is a brand new day, right #{self.user.first_name}?"])
          arr_sorry.push(["Well, it happens, #{self.user.first_name}. One day is all you need to start a new streak!"])
          arr_sorry.push(["Ok #{self.user.first_name}. One thing that works well for a lot of people: before you go to bed at night, write down in a journal your plan to succeed the next day. It works surprisingly well!"])
          arr_sorry.push(["Alright #{self.user.first_name}. Have you thought about what kept you from succeeding, and how you might be able to change that?"])
        else
          #if self.days_since_first_checkpoint >= 7
            last_7_days_count = self.success_count_during_past_n_days(7)
          #  if self.get_goal_days_per_week >= last_7_days_count
          #    arr_sorry.push(["No worries #{self.user.first_name}. You've already done it #{last_7_days_count} days out of the last 7 days!"])
          #    arr_sorry.push(["No problem, #{self.user.first_name}, 'cause you've already succeeded #{last_7_days_count} days out of the last 7 days!"])

          #  else
              arr_sorry.push(["Ok #{self.user.first_name}. During the last 7 days you've done it #{last_7_days_count} times. Try to hit #{self.get_goal_days_per_week} per week!"])
              arr_sorry.push(["Alright #{self.user.first_name}. Keep working toward #{self.get_goal_days_per_week} days a week, OK?"])
          #  end
          #else
            arr_sorry.push(["Ok #{self.user.first_name}. Just remember, try to hit #{self.get_goal_days_per_week} days out of the week."])
            arr_sorry.push(["Alright #{self.user.first_name}. Keep working toward #{self.get_goal_days_per_week} days a week, OK?"])
          #end

	end


        random_number = 0
        random_number = rand(arr_sorry.size) + 0 #between 0 and arr_sorry.size
        random_sorry = arr_sorry[random_number]
        phrase = random_sorry.to_s
        phrase = phrase.sub("xxx","''" + self.title + "''")

    end
    return phrase
  end
  
  def remove_if_duplicates(reporting_date)
    checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date = '#{reporting_date}'")
    if checkpoints
        if checkpoints.size > 1
            remove_this_many = checkpoints.size - 1 
            removed = 0
            for checkpoint in checkpoints
                if removed < remove_this_many
                    checkpoint.destroy
                    removed = removed + 1
                end
            end
        end
    end
  end

  def create_checkpoint_if_needed(reporting_date_string)
    reporting_date = reporting_date_string.to_date
    #logger.debug("sgj:reporting_date =" + reporting_date.to_s)
    checkpoint = Checkpoint.find(:first, :conditions => "goal_id = '#{self.id}' and checkin_date = '#{reporting_date}'")

    if !checkpoint
        if self.is_this_a_relevant_day(reporting_date)
            checkpoint = Checkpoint.new()
            checkpoint.status = "email not yet sent"
            checkpoint.checkin_date = reporting_date
            checkpoint.goal_id = self.id
            checkpoint.save
        end
    end
    return checkpoint
  end

  def update_checkpoint(reporting_date_string, status, comment = "")
    reporting_date = reporting_date_string.to_date
    success = true
    begin
        ### Not sure why this was there twice
        ###self.create_checkpoint_if_needed(reporting_date)
        checkpoint = self.create_checkpoint_if_needed(reporting_date)
        success = checkpoint.update_status(status, comment)
    rescue
        success = false
        logger.error "SGJ:error in update_checkpoint"
    end
    return success
  end

  def is_this_a_relevant_day(check_date_string)
    check_date = check_date_string.to_date
    ### do not allow creation of checkpoints prior to the original start date
    if self.first_start_date != nil

      #if check_date < self.start
      if check_date < self.first_start_date
	      return false
      end

    end

    dayname = check_date.strftime("%A")  
    if dayname == "Monday"
      return self.daym
    end
    if dayname == "Tuesday"
      return self.dayt
    end
    if dayname == "Wednesday"
      return self.dayw
    end
    if dayname == "Thursday"
      return self.dayr
    end
    if dayname == "Friday"
      return self.dayf
    end
    if dayname == "Saturday"
      return self.days
    end
    if dayname == "Sunday"
      return self.dayn
    end
    return false
  end

  def create_checkpoints_where_missing
      success = true

      begin




      dnow = self.user.dtoday
      dyesterday = dnow - 1

        #########################################
        ### FILL IN ANY CHECKPOINT GAPS
        ### CREATE CHECKPOINTS WHERE MISSING
        #########################################
        
        
        ### Does a checkpoint exist yet for "yesterday"? Do that first if needed
        ### (don't do "today" since that will cause stats to say "unsure")
        checkpoint_today = Checkpoint.find(:first, :conditions => "goal_id = '#{self.id}' and checkin_date = '#{dnow}'")
        if checkpoint_today == nil
            new_checkpoint_date = dnow - 1
            if self.is_this_a_relevant_day(new_checkpoint_date)
                double_check_checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date = '#{new_checkpoint_date}'")
                if double_check_checkpoints.size == 0
                    #logger.debug new_checkpoint_date.to_s + ' is a go... create this missing checkpoint'
                    #### START CREATE CHECK POINT
                    c_new = Checkpoint.new
                    self_id = self.id
                    c_new.checkin_date = new_checkpoint_date
                    c_new.status = "email not yet sent"
                    c_new.syslognote = "checkpoint created late, during auto-update process"
                    if c_new.save
                      #logger.info 'created missing checkpoint for user ' + self.user.email + ' for goal of ' + self.id.to_s + ' and date of ' + c_new.checkin_date.to_s
                    else
                      logger.error 'error creating missing checkpoint for user ' + self.user.email + ' for goal of ' + self.id.to_s + ' and date of ' + c_new.checkin_date.to_s
                    end
                    #### END CREATE CHECKPOINT
                end
            else
                #logger.debug new_checkpoint_date.to_s + ' is a skip day'
            end
        end

       
        ### NOW CHECK FOR GAPS AND FILL IN WHERE NEEDED
        checkpoints_all = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}'", :order =>  "checkin_date desc")
        if checkpoints_all != nil
            passed_the_first_one = 0
            previous_date = dnow - 1
            
            for c in checkpoints_all
                if passed_the_first_one == 0
                    #logger.debug "SGJ 1.1"
                    passed_the_first_one = 1
                    previous_date = c.checkin_date
                    #logger.debug 'first checkpoint date =' + previous_date.to_s
                    #logger.debug "SGJ 1.2"
                else
                    #logger.debug "SGJ 2.1"
                    gap = previous_date - c.checkin_date
                    #logger.debug 'gap between ' + previous_date.to_s + ' and ' + c.checkin_date.to_s + ' = ' + gap.to_s
                    if gap > 1
                        #logger.debug 'GAP GREATER THAN 1... CHECK FOR DAYS OF WEEK'

                        traverse_counter = 1
                        while traverse_counter < gap
                            new_checkpoint_date = previous_date - traverse_counter
 #logger.debug "SGJa " + new_checkpoint_date.to_s + " "+ self.is_this_a_relevant_day(new_checkpoint_date).to_s

                            if self.is_this_a_relevant_day(new_checkpoint_date)
                                #logger.debug new_checkpoint_date.to_s + ' is a go... create this missing checkpoint'
 #logger.debug "SGJb"

                                double_check_checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date = '#{new_checkpoint_date}'")
                                if double_check_checkpoints.size == 0
 #logger.debug "SGJc"

                                  #### START CREATE CHECK POINT
                                  c_new = Checkpoint.new
                                  self_id = self.id
                                  c_new.checkin_date = new_checkpoint_date
                                  c_new.status = "email not yet sent"
                                  c_new.syslognote = "checkpoint created late, during auto-update process"
 #logger.debug "SGJd"

                                  if c_new.save
                                    #logger.info 'created missing checkpoint for user ' + self.user.email + ' for goal of ' + self.id.to_s + ' and date of ' + c_new.checkin_date.to_s
                                  else
                                    logger.error 'error creating missing checkpoint for user ' + self.user.email + ' for goal of ' + self.id.to_s + ' and date of ' + c_new.checkin_date.to_s
                                  end
                                  #### END CREATE CHECKPOINT
                                end    
                            else
                                #logger.debug new_checkpoint_date.to_s + ' is a skip day'
                            end
                            traverse_counter = traverse_counter + 1

                        end
                    end
                    #logger.debug "SGJ 2.2"

                    previous_date = c.checkin_date
                end
            end
        end
        #########################################
        ### END FILL IN ANY CHECKPOINT GAPS
        ### END CREATE CHECKPOINTS WHERE MISSING
        #########################################
#logger.debug "SGJ 3"

        rescue
            success = false
            logger.error "SGJ:error in create_checkpoints_where_missing"
        end

      return success
  end


  def update_last_status_and_date(checkpoint)
    success = true
    begin
        #####################################################################
        #### Update the goal w/ the last status and date (if it is the last)
        #####################################################################
        laststatusdate = self.laststatusdate
        if laststatusdate == nil
          laststatusdate = Date.new(1900,1,1)
        end

        if checkpoint.status == "yes"
          if (self.last_success_date == nil) or (checkpoint.checkin_date > self.last_success_date)
	    self.last_success_date = checkpoint.checkin_date

            self.next_push_on_or_after_date = self.last_success_date + 3
            self.save

            begin
              ### now check to see what days are relevant, and bump the next push date as needed
              check_date_relevant = self.next_push_on_or_after_date - 2
              if !self.is_this_a_relevant_day(check_date_relevant.to_s)
                self.next_push_on_or_after_date = self.next_push_on_or_after_date + 1
              end

              check_date_relevant = check_date_relevant + 1
              if !self.is_this_a_relevant_day(check_date_relevant.to_s)
                self.next_push_on_or_after_date = self.next_push_on_or_after_date + 1
              end

              check_date_relevant = check_date_relevant + 1
              if !self.is_this_a_relevant_day(check_date_relevant.to_s)
                self.next_push_on_or_after_date = self.next_push_on_or_after_date + 1
              end

              self.save
            rescue
              logger.error("sgj:goal.rb:error trying to move the push date forward for goal_id:" + self.id.to_s)
            end

          end
        end

        if checkpoint.checkin_date > laststatusdate
          self.laststatusdate = checkpoint.checkin_date
          self.laststatus = checkpoint.status
          self.save
        end
        #####################################################################
        #### END Update the goal w/ the last status and date (if it is the last)
        #####################################################################
    rescue
        success = false
        logger.error "SGJ:error in update_last_status_and_date(checkpoint)"
    end
    return success
  end

  def reset_start_date_if_needed
      success = true
      begin
        #####################################################################
        ###      Reset the start date if needed
        #####################################################################    
    
        dnow = self.user.dtoday
        
        ### only if the goal is not monitored
        if self.status != 'monitor'
          keep_going = "yes"
          first_checkpoint_date = dnow
      
          ### count backward from the most recent checkpoints
          checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}'", :order =>  "checkin_date desc")
          for checkpoint in checkpoints
            ### if you have reason to keep looking backward for a new start date
            if keep_going == "yes"
              ### the first "no" that you come across, that + 1 is your new start date and you can stop looking
              if checkpoint.status == "no"
                newstart = checkpoint.checkin_date + 1            
                keep_going = "no"
              end 
            end  
            first_checkpoint_date = checkpoint.checkin_date
          end 
          if keep_going == "yes"
            ### you never found a "no", so just to be safe, reset your start date to the first checkpoint's date
            newstart = first_checkpoint_date
          end                   
          self.start = newstart
          self.stop = self.start + self.days_to_form_a_habit
          self.save
        end
        #####################################################################
        ###      End reset the start date if needed
        #####################################################################    
    rescue
        success = false
        logger.error "SGJ:error in reset_start_date_if_needed"
    end
    return success
  end

  def is_habit_established
      if self.established_on != nil and self.established_on > "1900-01-01"
        return true
      else
        return false
      end    
  end
  def update_if_habit_established
      success = true
      begin
        ############################################################
        ##### DETERMINE WHETHER GOAL HAS BEEN ESTABLISHED ########
        ############################################################
        checkpoints_range = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date >= '#{self.start}' and checkin_date <= '#{self.stop}' and status = 'yes'")
        mystring = checkpoints_range.size
        if self.status == "start" and checkpoints_range.size > (self.days_to_form_a_habit - 1)
          checkpoints_missing = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date >= '#{self.start}' and checkin_date <= '#{self.stop}' and (status = 'email sent' or status = 'email failure' or status = 'email not yet sent' or status = 'email queued')")
          if checkpoints_missing.size > 0
            ###missing checkpoints, can't call it yet
          else
            ### goal has been met... set established_on date
            self.established_on = self.stop
            self.save        
          end
        end
        ############################################################
        ##### END DETERMINE WHETHER GOAL HAS BEEN ESTABLISHED ########
        ############################################################
      rescue
          success = false
          logger.error "SGJ:error in update_if_habit_established"          
      end
      return success
  end

  def get_latest_stats_badge_details
      ### ONLY CALLING THIS FROM EMAILS, NOT WEB ... 
      ### on web, seems to not show latest even when removing caching feature
      #if self.last_stats_badge_date == nil or (self.user.dtoday > self.last_stats_badge_date)
        self.update_stats
      #end

      return self.last_stats_badge_details
  end


  def get_latest_stats_badge
      ### ONLY CALLING THIS FROM EMAILS, NOT WEB ... 
      ### on web, seems to not show latest even when removing caching feature
      #if self.last_stats_badge_date == nil or (self.user.dtoday > self.last_stats_badge_date)
        self.update_stats
      #end

      return self.last_stats_badge
  end

  def update_stats
        #logger.debug("sgj:running goal.update_stats on: " + self.title)
        success = true
        begin
            ####################################################
            ####    CALCULATE STATS
            ####################################################
            totalsize = self.number_of_checkpoints
            if totalsize > 0      

              #### SUCCESSS RATES ARE NOW LAGGING RATES
              got_one = false
              age_counter = 30
              while age_counter > 0
                if !got_one and self.days_since_first_checkpoint >= age_counter
                  #logger.debug("sgj: age_counter= " + age_counter.to_s)
                  self.success_rate_percentage = self.success_rate_during_past_n_days(age_counter)
                  #logger.debug("sgj: self.success_rate_percentage = " + self.success_rate_percentage.to_s)
                  got_one = true
                end
                age_counter = age_counter - 1
              end   

              #self.success_rate_percentage = self.percent_of_checkpoints_with_answer_of_yes
              self.days_into_it = totalsize

              ### not writing both to db since it ends up being over 255 char
              ### and the only real intensive task is the text output calculation
              self.last_stats_badge = self.stats_image
              self.last_stats_badge_details = self.stats_output

              self.last_stats_badge_date = self.user.dtoday

              self.save            
            end 
            ####################################################
            ####    END CALCULATE STATS
            ####################################################

            

        rescue
            success = false
            logger.error "SGJ:error in update_stats"
        end
        return success
  end

  def auto_extend_3_weeks_if_monitoring
      success = true
      begin
        dnow = self.user.dtoday
        ########################
        ### AUTO-EXTEND 3 WEEKS IF MONITORING
        ###
        ### when a goal is monitored, 
        ### when someone checks in, 
        ### make sure the end date is at least 2-3 weeks away
        ### this way you'll rarely need to ask someone to extend
        ################################################
        if self.status == "monitor"
            if self.stop < (dnow + 14)
              self.stop = dnow + 21          
              self.save                
            end
        end
        ########################
        ### END AUTO-EXTEND 2 WEEKS IF MONITORING
        ########################
      rescue
          success = false
          logger.error "SGJ:error in auto_extend_3_weeks_if_monitoring"
      end
      return success
  end

  def get_daily_status_for(reporting_date)
      checkpoint = self.create_checkpoint_if_needed(reporting_date)
      if checkpoint
          return checkpoint.status
      else
          return false
      end
  end

  def get_daily_comment_for(reporting_date)
      checkpoint = self.create_checkpoint_if_needed(reporting_date)
      if checkpoint
          return checkpoint.comment
      else
          return false
      end
  end


  def is_part_of_a_team
    if self.team != nil
        if self.team_goals
            return true
        else
            return false
        end
    else
        return false
    end      
  end

  def team_goals
      team_goals = Goal.find(:all, :conditions => "team_id = '#{self.team_id}'")
  end
  def get_teammate_names_sans_me
    names = ""
    for goal in self.team_goals
        if goal.user and (goal.user != self.user)
            if names != ""
                names = names + ", "
            end
            names = names + goal.user.first_name 
        end
    end
    return names
  end
  
  def quit_a_team
      success = true
      begin

        ##################################################################    
        #Start Quit Team Code
        ##################################################################    
        #
        #Pseudocode:
        #
        #if member requests removal
        #   remove
        #   decrement team.qty_current
        #   evaluate and set team.has_opening
        #   send removal notice to members
        #-->                                                              

        if self.team_id != nil
            team = Team.find(:first, :conditions => "id = '#{self.team_id}'")            
            if team
                ### Modify teamgoal record
                teamgoal = Teamgoal.find(:first, :conditions => "goal_id = '#{self.id}' and team_id = '#{self.team_id}'")
                if teamgoal
                    teamgoal.active = 0
                    teamgoal.save      
                else
                    #logger.debug("SGJ TEAM: no teamgoal found")
                end

                ### Modify and Save Team
                team.qty_current = team.qty_current - 1
                if team.qty_current < 0
                    team.qty_current = 0
                end 
                if team.qty_current >= team.qty_max
                    team.has_opening = 0
                else
                    team.has_opening = 1
                end
                team.save  

                ### Modify and Save Goal
                self.team_id = nil
                self.save
                
                
                #### 
                #### TODO !!!
                ##### WE SHOULD SEND A NOTICE TO THE OTHER MEMBERS !!!!
                
            end  
        else
            logger.error("SGJ TEAM: can't quit the team ... you're not on one")
        end


      rescue
          success = false
          logger.error "SGJ TEAM: failed in goal.quit_a_team"
          success = false
      end
  end
  
  def join_goal_to_a_team
      success = true
      begin

       ##################################################################    
       #Start Join Team Code
       ##################################################################    
       #
       #Pseudocode:
       #
       #if user requests to add a goal to a team
       #  if a team.has_opening exists for that category (on a team that I'm not already on)
       #    add goal to the team
       #    increment team.qty_current
       #    evaluate and set team.has_opening
       #    notify members of team
       #    notify new member
       #  else
       #    create a team
       #    add goal to team
       #    notify new member
       #    let member name team    
       ##############

        if self.team_id == nil
            team_with_openings = Team.find(:first, :conditions => "category_name = '#{self.category}' and has_opening = 1")
            if team_with_openings
                already_on_that_team = Goal.find(:first, :conditions => "user_id = '#{self.user.id}' and team_id = '#{team_with_openings.id}'")
            end
        
            if team_with_openings and !already_on_that_team
                #logger.debug("TEAM: found team_with_openings")

                ### Create a new teamgoal record
                new_teamgoal = Teamgoal.new()
                new_teamgoal.team_id = team_with_openings.id
                new_teamgoal.goal_id = self.id
                new_teamgoal.qty_kickoff_votes = 0
                new_teamgoal.active = 1
                new_teamgoal.save  

                ### Modify and Save Team
                team_with_openings.qty_current = team_with_openings.qty_current + 1 
                if team_with_openings.qty_current >= team_with_openings.qty_max
                    team_with_openings.has_opening = 0
                else
                    team_with_openings.has_opening = 1
                end
                team_with_openings.save  


                ### Modify and Save Goal
                self.team = team_with_openings
                self.save
            else
                if already_on_that_team
                    #logger.debug("TEAM: found team_with_openings, but you're already on it, so create a different one")
                else
                    #logger.debug("TEAM: no team_with_openings ... create one")
                end

                ### Create a new team
                new_team = Team.new()
                new_team.category_name = self.category
                new_team.save  
 
                ### Add to the new team 
                ### make sure a record is being inserted to teamgoal 
                self.team = new_team
                self.save       
        
                ### Modify and Save Team
                new_team.qty_max = 4
                new_team.qty_current = 1
                new_team.has_opening = 1
                new_team.save  


                ### Create a new teamgoal record
                new_teamgoal = Teamgoal.new()
                new_teamgoal.team_id = new_team.id
                new_teamgoal.goal_id = goal.id
                new_teamgoal.qty_kickoff_votes = 0
                new_teamgoal.active = 1
                new_teamgoal.save  
            end  
        else
            #logger.debug("SGJ TEAM: already on a team")
        end
        #################################################################
        ###   END Join Team code    
        #################################################################
          
      rescue
          logger.error "SGJ TEAM: failed in goal.join_goal_to_a_team"
          success = false
      end
      return success
  end
  
  def my_active_bets
      my_bets = Bet.find(:all, :conditions => "goal_id = '#{self.id}' and active_yn = 1 and end_date >= '#{self.user.dtoday}' and fire_type = 1") 
  end
  
  def number_my_active_bets
    count = 0
    begin
      if self.my_active_bets and self.my_active_bets.size != nil
          count = self.my_active_bets.size
      end      
    rescue

    end

    return count
  end  


  def success_count_during_past_n_days(number_of_days)
    yes_count = 0
    begin

        ### Do not include today unless today is already a "yes" or a "no"
        today_checkpoint = Checkpoint.find(:first, :conditions => "goal_id = '#{self.id}' and checkin_date = '#{self.user.dtoday}' and status != 'yes' and status != 'no'")
        if today_checkpoint
            date2 = self.user.dyesterday
        else
            date2 = self.user.dtoday
        end

        date1 = date2 - number_of_days
        yes_count = success_count_between_dates(date1,date2)    
    rescue
       logger.error "SGJ error in goals.success_count_during_past_n_days" 
    end
    return yes_count
  end


  def success_rate_during_past_n_days(number_of_days)
    yes_percent = 0
    relative_success_rate = 0
    begin

        ### Do not include today unless today is already a "yes" or a "no"
        today_checkpoint = Checkpoint.find(:first, :conditions => "goal_id = '#{self.id}' and checkin_date = '#{self.user.dtoday}' and status != 'yes' and status != 'no'")
        if today_checkpoint
            date2 = self.user.dyesterday
        else
            date2 = self.user.dtoday
        end

        date1 = date2 - number_of_days + 1 #### if you do not add 1 then you end up with one too many checkpoints which throws off the stats
        yes_percent = success_rate_between_dates(date1,date2)    

        relative_success_rate = (((yes_percent + 0.0) / self.desired_success_rate)*100).floor
        if relative_success_rate > 100
          relative_success_rate = 100
        end
        #logger.info("sgj:yes_percent during last " + number_of_days.to_s +  " days is" + yes_percent.to_s + " and relative_success_rate = " + relative_success_rate.to_s)

    rescue
       logger.error "SGJ error in goals.success_rate_during_past_n_days" 
    end

    return relative_success_rate
    #return yes_percent
  end

  def success_count_between_dates(date1,date2)
    yes_count = 0
    begin
        my_checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date >= '#{date1}' and checkin_date <= '#{date2}'")
        checkpoints_yes = Checkpoint.find(:all, :conditions => "status = 'yes' and goal_id = '#{self.id}' and checkin_date >= '#{date1}' and checkin_date <= '#{date2}'")
        if my_checkpoints.size > 0
            yes_count = checkpoints_yes.size 
        end
    rescue
        logger.error "SGJ error in goals.success_count_between_dates(date1,date2)"
    end
    return yes_count
  end

  def success_rate_between_dates(date1,date2)
    yes_percent = 0
    begin
        ### no longer bothering to count checkpoints, because
        ### if someone changes their relevant days per week,
        ### there may be some missing (or too many) checkpoints for the new "days per week"
        ### so instead, we'll count the number of days between the 2 dates in question
        #my_checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date >= '#{date1}' and checkin_date <= '#{date2}'")
        my_checkpoints = 0
        my_checkpoints = (date2 - date1) + 1 ### since dtoday - dyesterday = 1 but that would be 2 checkpoints


        checkpoints_yes = Checkpoint.find(:all, :conditions => "status = 'yes' and goal_id = '#{self.id}' and checkin_date >= '#{date1}' and checkin_date <= '#{date2}'")
        #if my_checkpoints.size > 0
        if my_checkpoints > 0
            #yes_percent = (((checkpoints_yes.size + 0.0) / my_checkpoints.size)*100).floor 
            yes_percent = (((checkpoints_yes.size + 0.0) / my_checkpoints)*100).floor 

        end

    rescue
        logger.error "SGJ error in goals.success_rate_between_dates(date1,date2)"
    end
    return yes_percent
  end


  def show_wins_last_week_monday_through_sunday
    show_me = false
    ### show only if the goal was active before this monday
    if self.date_of_first_checkpoint <= self.user.when_was_last_week_monday
        show_me = true
    end
    return show_me
  end
  
  def wins_last_week_monday_through_sunday
    ###Calculate number of "yes" answers from last Monday through Sunday
    wins_last_week = 0
    mywins_last_week = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date >= '#{self.user.when_was_last_week_monday}' and checkin_date <= '#{self.user.when_was_last_week_sunday}' and status = 'yes'")
    if mywins_last_week
        wins_last_week = mywins_last_week.size
    end
    return wins_last_week
  end

  def show_wins_this_week_since_monday
    show_me = false
    ### show only if the goal was active before this monday
    if self.date_of_first_checkpoint <= self.user.when_was_this_week_monday
        show_me = true
    end
    return show_me
  end

  def wins_this_week_since_monday

    ###Calculate number of "yes" answers from Monday through now
    ###   dmonday = ? 
    ###   through dnow

    wins_this_week = 0

    wins_since_monday = Checkpoint.find(:all, :conditions => "goal_id = '#{self.id}' and checkin_date >= '#{self.user.when_was_this_week_monday}' and status = 'yes'")
    if wins_since_monday
        wins_this_week = wins_since_monday.size
    end

    return wins_this_week

  end

  def last_week_results
    last_week_result = ""
    last_week_image = ""
    last_week_wins = ""
    if self.show_wins_last_week_monday_through_sunday
        last_week_wins = self.wins_last_week_monday_through_sunday.to_s
        last_week_margin = self.wins_last_week_monday_through_sunday - self.get_goal_days_per_week
        last_week_image = "<img src='/images/thumbs_up.png' alt='Thumbs Up!' width=25 border='0'/> "
        if last_week_margin == 0 
            last_week_result = "you met your goal!"
        end
        if last_week_margin < 0 
            last_week_result = "you fell short of your goal by #{last_week_margin * (-1)} days."
            last_week_image = "<img src='/images/thumbs_down.png' alt='Thumbs Down.' width=25 border='0'/> "
        end
        if last_week_margin > 0 
            last_week_result = "you exceeded your goal by #{last_week_margin} days!"
        end
    end

    win_or_wins = " wins..."
    if last_week_wins == "1"
        win_or_wins = " win..."
    end
    last_week_result = "Last week (Mon-Sun): " + last_week_image + last_week_wins + win_or_wins + last_week_result
    
    return last_week_result
  end

  def this_week_results
    this_week_result = ""
    this_week_image = ""
    this_week_wins = ""
    if self.show_wins_this_week_since_monday
        this_week_result = "your goal is #{self.get_goal_days_per_week}."
        this_week_wins = self.wins_this_week_since_monday.to_s
        this_week_margin = self.wins_this_week_since_monday - self.get_goal_days_per_week
        if this_week_margin == 0 
            this_week_result = "you've already met your goal!"
            this_week_image = "<img src='/images/thumbs_up.png' alt='Thumbs Up!' width=25 border='0'/> "
        end
        if this_week_margin > 0 
            this_week_result = "you've already exceeded your goal by #{this_week_margin}!"
            this_week_image = "<img src='/images/thumbs_up.png' alt='Thumbs Up!' width=25 border='0'/> "
        end
    end

    win_or_wins = " wins "
    if this_week_wins == "1"
        win_or_wins = " win "
    end
    this_week_result = "Since Monday: " + this_week_image + this_week_wins + win_or_wins + "so far this week..." + this_week_result
    

    return this_week_result
  end
  
  
  

  def update_bets_success_rates
      success = true
      begin
        if self.number_my_active_bets > 0
            for bet in self.my_active_bets
                bet.success_rate = bet.success_rate_dynamic
                bet.save
            end
        end
      rescue
          success = false
          logger.error "SGJ error in update_bets_success_rates"
      end
      return success
  end
  
  def invites_sent_to_followers
      invites_sent = Cheer.find(:all, :conditions => "goal_id = '#{self.id}'")
  end
  def number_invites_sent_to_followers
    count = 0
    if self.invites_sent_to_followers.size != nil
        count = self.invites_sent_to_followers.size
    end      
    return count
  end
  
end
