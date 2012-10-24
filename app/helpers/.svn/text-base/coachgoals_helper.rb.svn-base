module CoachgoalsHelper

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


end
