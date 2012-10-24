require 'active_record'
require 'date'
require 'logger'

  def get_dnow
      jump_forward_days = 0
      tnow = Time.now
      tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
      tnow_m = tnow.strftime("%m").to_i #month of the year
      tnow_d = tnow.strftime("%d").to_i #day of the month
      tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
      tnow_k = tnow.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
      tnow_M = tnow.strftime("%M").to_i #minute of the hour
      #puts tnow_Y + tnow_m + tnow_d  
      puts "Current timestamp is #{tnow.to_s}"
      dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days

      return dnow
  end

  def get_next_week_number(coachgoal)
    next_week_number = 0
    if coachgoal.week_4_email_sent_date == nil
        next_week_number = 4
    end
    if coachgoal.week_3_email_sent_date == nil
        next_week_number = 3
    end
    if coachgoal.week_2_email_sent_date == nil
        next_week_number = 2
    end
    if coachgoal.week_1_email_sent_date == nil
        next_week_number = 1
    end    
    return next_week_number
  end

  def get_next_send_date(coachgoal)
    next_send_date = get_dnow
    if coachgoal.week_4_email_sent_date == nil
        next_send_date = coachgoal.week_4_email_due_date
    end
    if coachgoal.week_3_email_sent_date == nil
        next_send_date = coachgoal.week_3_email_due_date
    end
    if coachgoal.week_2_email_sent_date == nil
        next_send_date = coachgoal.week_2_email_due_date
    end
    if coachgoal.week_1_email_sent_date == nil
        next_send_date = coachgoal.week_1_email_due_date
    end    
    return next_send_date
  end
  
class NotifyExtraaccDueForAnEmail < ActiveRecord::Base
  
  # This script:
  # finds Extra Accountability clients that are due for an accountability email
  # and notifies admin via email so that those emails can be sent


  dnow = get_dnow
  dnow_plus_3 = dnow + 3
  dnow_plus_6 = dnow + 6

  @coachgoals = Coachgoal.find(:all, :conditions => "is_active = '1'")
  for coachgoal in @coachgoals
      if coachgoal.week_4_email_sent_date != nil
          coachgoal.goal.is_coached = 0
          coachgoal.goal.coachgoal_id = 0
          coachgoal.goal.save
          
          coachgoal.is_active = 0
          coachgoal.save

          output_text = 'COACH ATTEMPTING TO Send email to coach re: fullfilled obligation'
          logger.info output_text
          puts output_text
          Notifier.deliver_coach_coachgoal_fulfilled_notification(coachgoal) # sends the email
          
      else
          ### Remind on the day of + every 3 days
          d_coachgoal = get_next_send_date(coachgoal)
          if dnow == d_coachgoal or dnow_plus_3 == d_coachgoal or dnow_plus_6 >= d_coachgoal

              output_text = 'COACH ATTEMPTING TO Send email to coach re: an email is due'
              logger.info output_text
              puts output_text
              Notifier.deliver_coach_coachgoal_email_due_notification(coachgoal) # sends the email
          else
              output_text = 'COACH coachgoal id of ' + coachgoal.id.to_s + ' next email not due yet' 
              logger.info output_text
              puts output_text
          end          
      end
  end
  
  puts "end of script"

end
