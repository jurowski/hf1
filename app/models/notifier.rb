class Notifier < ActionMailer::Base
  default_url_options[:host] = "habitforge.com"


  def get_random_subject()

    ### People complained about these being random
    ### cause it messed up their email groupings
    ### so you might want to just have one option
    
    arr_subject = Array.new
    #arr_subject.push(["HF: Daily Check-In ... How did you do yesterday?"])
    #arr_subject.push(["HF: So, yesterday... How did it go?"])
    arr_subject.push(["HF: Time to check in!"])
    #arr_subject.push(["HF: Your daily Check-In question... yes or no?"])

    random_number = 0
    random_number = rand(arr_subject.size) + 0 #between 0 and arr_subject.size
    random_subject = arr_subject[random_number]

    return random_subject.to_s
  end


  def get_random_subject_reminder(response_question = "your goal")
    #random_subject = "HF: Daily Check-In ... How did you do yesterday?"
    arr_subject = Array.new
    arr_subject.push(["[HF] Don't forget about \"#{response_question}\"!"])
    arr_subject.push(["[HF] Reminder about \"#{response_question}\" today."])
    arr_subject.push(["[HF] Add \"#{response_question}\" to your to-do list for today!"])

    random_number = 0
    random_number = rand(arr_subject.size) + 0 #between 0 and arr_subject.size
    random_subject = arr_subject[random_number]

    return random_subject.to_s
  end



  def user_expired_notification(user)
    recipients user.first_name + "<" + user.email + ">"
    #bcc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Renewal Notice: Your Premium Membership Has Expired."
    body       :user => user
    content_type "text/html"
  end 

  def user_expire_soon_notification(user)
    recipients user.first_name + "<" + user.email + ">"
    #bcc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Renewal Notice: Your Premium Membership Expires This Week!"
    body       :user => user
    content_type "text/html"
  end 



  def user_upgrade_3month_notification(user)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Premium Membership Account Upgrade"
    body       :user => user
  end  
  def user_upgrade_6month_notification(user)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Premium Membership Account Upgrade"
    body       :user => user
  end  
  def user_upgrade_notification(user)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Premium Membership Account Upgrade"
    body       :user => user
  end  
  def user_upgrade_2year_notification(user)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Supporting Membership Account Upgrade"
    body       :user => user
  end  
  def user_upgrade_5year_notification(user)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Supporting Membership Account Upgrade"
    body       :user => user
  end  



  def user_extraacc_upgrade_notification(coachgoal)
    recipients coachgoal.user.first_name + "<" + coachgoal.user.email + ">"
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "HabitForge Weekly Check-Ins and Upgrade"
    body       :coachgoal => coachgoal
  end  

  def user_extraacc_only_notification(coachgoal)
    recipients coachgoal.user.first_name + "<" + coachgoal.user.email + ">"
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "HabitForge Weekly Check-Ins"
    body       :coachgoal => coachgoal
  end  

  def bet_fire_charity_new_notification(user, bet, goal)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com, " + bet.recipient_name + "<" + bet.recipient_email + ">"
    from       "HabitForge <support@habitforge.com>"
    subject    "Thanks for Playing For a Cause!"
    body       :user => user, :bet => bet, :goal => goal
  end  

  def bet_fire_friend_new_notification(user, bet, goal)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com, " + bet.recipient_name + "<" + bet.recipient_email + ">"
    from       "HabitForge <support@habitforge.com>"
    subject    "Extra Accountability Challenge"
    body       :user => user, :bet => bet, :goal => goal
  end  

  def bet_fire_random_new_notification_to_user(user, bet, goal)
    recipients user.first_name + "<" + user.email + ">"
    bcc         "support@habitforge.com"
    from       "HabitForge <support@habitforge.com>"
    subject    "Extra Accountability Challenge"
    body       :user => user, :bet => bet, :goal => goal
  end  

  def bet_fire_random_new_notification_to_recipient(user, bet, goal)
    recipients bet.recipient_name + "<" + bet.recipient_email + ">"
    bcc         "support@habitforge.com"
    from       "HabitForge <support@habitforge.com>"
    subject    "Extra Accountability Challenge"
    body       :user => user, :bet => bet, :goal => goal
  end  


  def bet_fire_charity_due_notification(user, bet, floor_days, successful_days)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com, " + bet.recipient_name + "<" + bet.recipient_email + ">"
    from       "HabitForge <support@habitforge.com>"
    subject    user.first_name + "'s Challenge Period Results"
    body       :user => user, :bet => bet, :floor_days => floor_days, :successful_days => successful_days
  end  

  def bet_fire_friend_due_notification(user, bet, floor_days, successful_days)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com, " + bet.recipient_name + "<" + bet.recipient_email + ">"
    from       "HabitForge <support@habitforge.com>"
    subject    user.first_name + "'s Challenge Period Results"
    body       :user => user, :bet => bet, :floor_days => floor_days, :successful_days => successful_days
  end  

  def bet_fire_random_due_notification_to_user(user, bet, floor_days, successful_days)
    recipients user.first_name + "<" + user.email + ">"
    bcc         "support@habitforge.com"
    from       "HabitForge <support@habitforge.com>"
    subject    user.first_name + "'s Challenge Period Results"
    body       :user => user, :bet => bet, :floor_days => floor_days, :successful_days => successful_days
  end  

  def bet_fire_random_due_notification_to_recipient(user, bet, floor_days, successful_days)
    recipients bet.recipient_name + "<" + bet.recipient_email + ">"
    bcc         "support@habitforge.com"
    from       "HabitForge <support@habitforge.com>"
    subject    user.first_name + "'s Challenge Period Results"
    body       :user => user, :bet => bet, :floor_days => floor_days, :successful_days => successful_days
  end  




  def bet_fire_charity_due_notification_oops(user, bet, floor_days, successful_days)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com, " + bet.recipient_name + "<" + bet.recipient_email + ">"
    from       "HabitForge <support@habitforge.com>"
    subject    "PLEASE IGNORE re: " + user.first_name + "'s Challenge Period Results"
    body       :user => user, :bet => bet, :floor_days => floor_days, :successful_days => successful_days
  end  

  def bet_fire_friend_due_notification_oops(user, bet, floor_days, successful_days)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com, " + bet.recipient_name + "<" + bet.recipient_email + ">"
    from       "HabitForge <support@habitforge.com>"
    subject    "PLEASE IGNORE re: " + user.first_name + "'s Challenge Period Results"
    body       :user => user, :bet => bet, :floor_days => floor_days, :successful_days => successful_days
  end  

  def bet_fire_random_due_notification_to_user_oops(user, bet, floor_days, successful_days)
    recipients user.first_name + "<" + user.email + ">"
    bcc         "support@habitforge.com"
    from       "HabitForge <support@habitforge.com>"
    subject    "PLEASE IGNORE re: " + user.first_name + "'s Challenge Period Results"
    body       :user => user, :bet => bet, :floor_days => floor_days, :successful_days => successful_days
  end  

  def bet_fire_random_due_notification_to_recipient_oops(user, bet, floor_days, successful_days)
    recipients bet.recipient_name + "<" + bet.recipient_email + ">"
    bcc         "support@habitforge.com"
    from       "HabitForge <support@habitforge.com>"
    subject    "PLEASE IGNORE re: " + user.first_name + "'s Challenge Period Results"
    body       :user => user, :bet => bet, :floor_days => floor_days, :successful_days => successful_days
  end 



  def bet_added_notification(user)
    recipients user.first_name + "<" + user.email + ">"
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Thanks for Playing For a Cause!"
    body       :user => user
  end  

  def user_upgrade_unknown_notification(email)
    recipients email
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "What email address? (Question about your Supporting Membership Account Upgrade)"
    body       :email => email
  end  

  def user_extraacc_unknown_notification(email)
    recipients email
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "What email address? (Question about your Extra Accountability Upgrade)"
    body       :email => email
  end  

  def bet_goal_unknown_notification(email)
    recipients email
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Which goal? (Question about Play for a Cause)"
    body       :email => email
  end  

  def bet_user_unknown_notification(email)
    recipients email
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "What email address? (Question about Play for a Cause)"
    body       :email => email
  end  

  def coach_goal_unknown_notification(email)
    recipients email
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Which goal? (Question about Weekly Check-ins)"
    body       :email => email
  end  

  def coach_user_unknown_notification(email)
    recipients email
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "What email address? (Question about Weekly Check-ins)"
    body       :email => email
  end  

  def signup_notification(recipient)
    recipients recipient.first_name + "<" + recipient.email + ">"
    #bcc        ["jurowski@gmail.com"]
    from       "habitforge <support@habitforge.com>"
    subject    "New account information"
    body       :account => recipient
  end  

  def coach_coachgoal_notification(coachgoal)
    recipients	coachgoal.coach.user.email
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "Weekly Check-In Client Signup"
    body       :coachgoal => coachgoal
  end 

  def coach_coachgoal_email_due_notification(coachgoal)
    #recipients	coachgoal.coach.user.email
    recipients	"jurowski@gmail.com"
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "A Weekly Client Check-in Email is Due"
    body       :coachgoal => coachgoal
  end 

  def coach_coachgoal_fulfilled_notification(coachgoal)
    recipients	coachgoal.coach.user.email
    cc         "support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "4-Week Obligation Fulfilled!"
    body       :coachgoal => coachgoal
  end 
  
  def support_coachgoal_missing_coach_notification(coachgoal)
    recipients	"support@habitforge.com"
    from       "habitforge <support@habitforge.com>"
    subject    "MISSING COACH for Weekly Check-In Client Signup"
    body       :coachgoal => coachgoal
    content_type "text/html"
  end 


  def goal_creation_notification(goal)
    recipients	goal.user.email
    from       "habitforge <support@habitforge.com>"
    bcc         "support@habitforge.com"
    subject    "Goal Creation Notification"
    body       :goal => goal
    content_type "text/html"
  end

  def tomessage_rated_notification(to_user, from_user, tomessage, rating)
    recipients  to_user.email
    bcc        ["support@habitforge.com"]
    from       "No Reply-Messages <noreply-messages@habitforge.com>"

    if rating.to_i > 0
      subject "[HF] #{from_user.first_name} liked your message and sent you #{rating.to_s} Impact Points!"
    else
      subject "[HF] #{from_user.first_name} did not care for your message :( ... they docked you #{rating.to_s} Impact Points!"
    end

    body       :to_user => to_user, :from_user => from_user, :tomessage => tomessage, :rating => rating
    content_type "text/html"
  end


  def tomessage_notification(to_user, from_user, tomessage, from_type, goal_id = 0)
    recipients	to_user.email
    #bcc        ["jurowski@gmail.com"]
    from       "No Reply-Messages <noreply-messages@habitforge.com>"

    case from_type
    when "member"
      subject    "[HF] #{from_user.first_name} @ HabitForge sent you a boost"
    when "follower"
      subject    "[HF] You have a message from a HabitForge follower!" 
    when "team"
      subject    "[HF] You have a message from a HabitForge team mate!"
    else
      subject    "[HF] You have a message from a HabitForge supporter!"
    end

    body       :goal_id => goal_id, :to_user => to_user, :from_user => from_user, :tomessage => tomessage, :from_type => from_type
    content_type "text/html"
  end


  def pushmessage_to_slacker(from_user, to_user, slacker_goal, push_message)
    recipients  to_user.email
    #bcc        ["jurowski@gmail.com"]
    from       "No Reply-Messages <noreply-messages@habitforge.com>"
    subject    "You have received a 'push' from someone at HabitForge! (#{from_user.first_name} is counting on you to succeed w/in 48 hours!)"
    body       :to_user => to_user, :from_user => from_user, :slacker_goal => slacker_goal, :push_message => push_message
    content_type "text/html"
  end

  def succeeded_with_pushmessage_to_slacker(to_user, slacker_goal)
    recipients  to_user.email
    #bcc        ["jurowski@gmail.com"]
    from       "No Reply-Messages <noreply-messages@habitforge.com>"
    subject    "Your 'push' to #{slacker_goal.user.first_name} helped! You've earned another 10 SupportPoints!"
    body       :to_user => to_user, :slacker_goal => slacker_goal
    content_type "text/html"
  end

  def goal_creation_notification_clearworth(goal)
    recipients	goal.user.email
    from       "ClearWorth and HabitForge <support@habitforge.com>"
    subject    "Goal Creation Notification"
    bcc         "support@habitforge.com"
    body       :goal => goal
    content_type "text/html"
  end

  def goal_creation_notification_reengagefocus(goal)
    recipients	goal.user.email
    from       "reEngage Focus <support@reengagefocus.com>"
    subject    "Goal Creation Notification"
    bcc         "support@habitforge.com"
    body       :goal => goal
    content_type "text/html"
  end

  def goal_creation_notification_forittobe(goal)
    recipients	goal.user.email
    bcc         "support@habitforge.com"
    from       "For It To Be <support@forittobe.com>"
    subject    "Goal Creation Notification"
    body       :goal => goal
    content_type "text/html"
  end
  def goal_creation_notification_marriagereminders(goal)
    recipients	goal.user.email
    bcc         "support@habitforge.com"
    from       "Marriage Reminders <support@marriagereminders.com>"
    subject    "Goal Creation Notification"
    body       :goal => goal
    content_type "text/html"
  end



  #def invite_a_friend_to_track(goal, email)  
  #  recipients  email
  #  from        "habitforge <support@habitforge.com>"
  #  subject     "Want to help me track something?"  
  #  body        :goal => goal
  #  content_type "text/html"
  #end
  def invite_a_friend_to_track(user, email, the_body, the_subject)  
    recipients  email
    #bcc         "support@habitforge.com"
    from        user.first_name + " via habitforge <support@habitforge.com>"
    subject     the_subject  
    body        the_body
    content_type "text/html"
  end


  def invite_a_friend_to_team(user, email, the_body, the_subject)  
    recipients  email
    bcc         "support@habitforge.com"
    from        user.first_name + " via habitforge <support@habitforge.com>"
    subject     the_subject  
    body        the_body
    content_type "text/html"
  end

  def daily_team_summary_to_user(goal, day_of_the_week)
    recipients goal.user.first_name + "<" + goal.user.email + ">"
    #bcc        ["jurowski@gmail.com"]
    from       "HabitForge <support@habitforge.com>"

    if goal.category
      subject    "[HF] the #{day_of_the_week} Lunchbreak: #{goal.category} Team Activity Report"
    else
      subject    "[HF] the #{day_of_the_week} Lunchbreak: Team Activity Report"
    end
    body       :goal => goal
    content_type "text/html"
  end

  ### watcher
  def weekly_report_of_goals_i_follow(user, arr_goals_to_email_me_about, day_of_the_week)
    recipients user.first_name + "<" + user.email + ">"
    #recipients "jurowski@gmail.com"
    #bcc        ["support@habitforge.com"]
    from       "HabitForge <support@habitforge.com>"
    subject    "[HF] #{day_of_the_week}'s Weekly Goal Follower Report"
    body       :user => user, :arr_goals_to_email_me_about => arr_goals_to_email_me_about
    content_type "text/html"
  end


  def notify_user_new_follower(goal, follower)
    recipients  goal.user.email
    #bcc         ["jurowski@gmail.com"]
    from        "HabitForge <noreply-messages@habitforge.com>"
    subject     "[HF] You have a new follower!"
    body        :goal => goal, :follower => follower
    content_type "text/html"
  end

  def daily_reminder_to_user(goal)
    recipients goal.user.email
    #recipients checkpoint.goal.user.first_name + "<" + checkpoint.goal.user.email + ">"
    #bcc        ["jurowski@gmail.com"]
    from       "HabitForge Reminder <noreplygoalcheckpoint@habitforge.com>"
    subject    get_random_subject_reminder(goal.response_question)
    body       :goal => goal
    content_type "text/html"
  end




  def daily_reminder_to_user_clearworth(goal)
    recipients goal.user.email
    #recipients checkpoint.goal.user.first_name + "<" + checkpoint.goal.user.email + ">"
    #bcc        ["jurowski@gmail.com"]
    
    ### THIS WILL BREAK IF YOU USE MYLEARNINGHABIT.COM
    from       "My Learning Habit Reminder <noreplygoalcheckpoint@habitforge.com>"
    subject    get_random_subject_reminder(goal.response_question)
    body       :goal => goal
    content_type "text/html"
  end  
  
  def daily_reminder_to_user_forittobe(goal)
    recipients goal.user.email
    #recipients checkpoint.goal.user.first_name + "<" + checkpoint.goal.user.email + ">"
    #bcc        ["jurowski@gmail.com"]
    from       "For It To Be Reminder <noreplygoalcheckpoint@habitforge.com>"
    subject    get_random_subject_reminder(goal.response_question)
    body       :goal => goal
    content_type "text/html"
  end
  
  
  def checkpoint_notification(checkpoint)
    
    recipients checkpoint.goal.user.email
    #recipients checkpoint.goal.user.first_name + "<" + checkpoint.goal.user.email + ">"
    #bcc        ["jurowski@gmail.com"]
    from       "HabitForge Daily Check-In <noreplygoalcheckpoint@habitforge.com>"
    #subject    get_random_subject
    subject    "HF: Time to check in!"
    body       :checkpoint => checkpoint
    content_type "text/html"
  end

  def checkpoint_notification_sameday(checkpoint)
    
    recipients checkpoint.goal.user.email
    #recipients checkpoint.goal.user.first_name + "<" + checkpoint.goal.user.email + ">"
    #bcc        ["jurowski@gmail.com"]
    from       "HabitForge Daily Check-In <noreplygoalcheckpoint@habitforge.com>"
    #subject    get_random_subject
    subject    "HF: Time to check in!"
    body       :checkpoint => checkpoint
    content_type "text/html"
  end

  def checkpoint_notification_clearworth(checkpoint)
    recipients checkpoint.goal.user.email
    #recipients checkpoint.goal.user.first_name + "<" + checkpoint.goal.user.email + ">"
    #bcc        ["jurowski@gmail.com"]
    from       "My Learning Habit Checkpoint <noreplygoalcheckpoint@habitforge.com>"
    subject    "Goal Checkpoint Notification"
    body       :checkpoint => checkpoint
    content_type "text/html"
  end

  def checkpoint_notification_sameday_clearworth(checkpoint)
    recipients checkpoint.goal.user.email
    #recipients checkpoint.goal.user.first_name + "<" + checkpoint.goal.user.email + ">"
    #bcc        ["jurowski@gmail.com"]
    from       "My Learning Habit Checkpoint <noreplygoalcheckpoint@habitforge.com>"
    subject    "Goal Checkpoint Notification"
    body       :checkpoint => checkpoint
    content_type "text/html"
  end


  def checkpoint_notification_forittobe(checkpoint)
    recipients checkpoint.goal.user.email
    #recipients checkpoint.goal.user.first_name + "<" + checkpoint.goal.user.email + ">"
    #bcc        ["jurowski@gmail.com"]
    from       "For It To Be Goal Checkpoint <noreplygoalcheckpoint@habitforge.com>"
    subject    "Goal Checkpoint Notification"
    body       :checkpoint => checkpoint
    content_type "text/html"
  end


  def checkpoint_notification_sameday_forittobe(checkpoint)
    recipients checkpoint.goal.user.email
    #recipients checkpoint.goal.user.first_name + "<" + checkpoint.goal.user.email + ">"
    #bcc        ["jurowski@gmail.com"]
    from       "For It To Be Goal Checkpoint <noreplygoalcheckpoint@habitforge.com>"
    subject    "Goal Checkpoint Notification"
    body       :checkpoint => checkpoint
    content_type "text/html"
  end


  def checkpoint_notification_multiple(checkpoint)

    recipients checkpoint.goal.user.email
    from       "HabitForge Daily Check-In <noreplygoalcheckpoint@habitforge.com>"
    subject    get_random_subject
    body       :checkpoint => checkpoint
    content_type "text/html"
  end

  def checkpoint_notification_multiple_sameday(checkpoint)

    recipients checkpoint.goal.user.email
    from       "HabitForge Daily Check-In <noreplygoalcheckpoint@habitforge.com>"
    subject    get_random_subject
    body       :checkpoint => checkpoint
    content_type "text/html"
  end

  def checkpoint_notification_multiple_clearworth(checkpoint)
    recipients checkpoint.goal.user.email
    from       "My Learning Habit Checkpoint <noreplygoalcheckpoint@habitforge.com>"
    subject    "Multi-Goal Checkpoint Notification"
    body       :checkpoint => checkpoint
    content_type "text/html"
  end

  def checkpoint_notification_multiple_sameday_clearworth(checkpoint)
    recipients checkpoint.goal.user.email
    from       "My Learning Habit Checkpoint <noreplygoalcheckpoint@habitforge.com>"
    subject    "Multi-Goal Checkpoint Notification"
    body       :checkpoint => checkpoint
    content_type "text/html"
  end


  def checkpoint_notification_multiple_forittobe(checkpoint)
    recipients checkpoint.goal.user.email
    from       "For It To Be Goal Checkpoint <noreplygoalcheckpoint@habitforge.com>"
    subject    "Multi-Goal Checkpoint Notification"
    body       :checkpoint => checkpoint
    content_type "text/html"
  end


  def checkpoint_notification_multiple_sameday_forittobe(checkpoint)
    recipients checkpoint.goal.user.email
    from       "For It To Be Goal Checkpoint <noreplygoalcheckpoint@habitforge.com>"
    subject    "Multi-Goal Checkpoint Notification"
    body       :checkpoint => checkpoint
    content_type "text/html"
  end

  
  def widget_user_creation(user, weekdays_only = "false")
    recipients	user.email
    bcc         "support@habitforge.com"
    from	"habitforge <support@habitforge.com>"
    subject	"Activate your new habit goal!"
    if weekdays_only == "true"
	weekdays_only = "&weekdays_only=true&monitor=1"
    else
        weekdays_only = "&weekdays_only=false"
    end
    body	:user => user, :activation_url => "http://habitforge.com/goals/new?diu=" + user.id.to_s + "&ptm=43" + user.password_temp + "9cth" + weekdays_only
  end 
  
  
  def password_reset_instructions(user)  
    recipients  user.email
    from        "habitforge <support@habitforge.com>"
    subject     "Password Reset Instructions"  
    body        :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
    #body        :user => user  
  end
  def password_reset_instructions_clearworth(user)  
    recipients  user.email
    from        "ClearWorth and HabitForge <support@habitforge.com>"
    subject     "Password Reset Instructions"  
    body        :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
    #body        :user => user  
  end
  def password_reset_instructions_reengagefocus(user)  
    recipients  user.email
    from        "reEngage Focus <support@reengagefocus.com>"
    subject     "Password Reset Instructions"  
    body        :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
    #body        :user => user  
  end

  def password_reset_instructions_forittobe(user)  
    recipients  user.email
    from        "For It To Be <support@forittobe.com>"
    subject     "Password Reset Instructions"  
    body        :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
    #body        :user => user  
  end
  def password_reset_instructions_marriagereminders(user)  
    recipients  user.email
    from        "Marriage Reminders <support@marriagereminders.com>"
    subject     "Password Reset Instructions"  
    body        :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
    #body        :user => user  
  end
  
  
  
  def tell_a_friend(user, email, the_body, the_subject)  
    recipients  email
    from        user.email
    subject     the_subject  
    body        the_body
  end

  def promotion_1(user, the_subject)  
    recipients  user.email
    from        "habitforge <newyear@habitforge-info.com>"
    subject     the_subject
    body        :user => user
    content_type "text/html"
  end

  def user_confirm(user, the_subject)
    recipients  user.email
    from        "habitforge <support@habitforge.com>"
    subject     the_subject
    body        :user => user
    content_type "text/html"
  end

  def user_ask_for_testimonial(user, the_subject)
    recipients  user.email
    #bcc         "support@habitforge.com"
    from        "habitforge <support@habitforge.com>"
    subject     the_subject
    body        :user => user
    content_type "text/html"
  end

  def promo_comeback(user, the_subject)
    recipients  user.email
    from        "habitforge <support@habitforge.com>"
    subject     the_subject
    body        :user => user
    content_type "text/html"
  end

  def notify_support(goal)  
    recipients  "support@habitforge.com, jurowski@gmail.com"
    from        "habitforge <support@habitforge.com>"
    subject     "checkpoint failure-will retry"
    body        :goal => goal
  end

  def notify_support_stats(stat)  
    subject_text = "hf_cron: "
    if stat.usersnewcreated
      subject_text += stat.usersnewcreated.to_s + " new users"
    else
      subject_text += "0 new users"
    end
    if stat.checkpointemailssent
      subject_text += "; " + stat.checkpointemailssent.to_s + " checkpoint emails sent"
    end
    recipients  "jurowski@gmail.com"
    from        "habitforge <support@habitforge.com>"
    subject     subject_text
    body        :stat => stat
  end


  def notify_support_script_error(script, log)
    recipients  "jurowski@gmail.com"
    cc          "support@habitforge.com"
    from        "habitforge <support@habitforge.com>"
    subject     "a script died unexpectedly: " + script 
    body        :script => script, :log => log
  end


  def notify_support_error(founderrors)  
    recipients  "jurowski@gmail.com"
    from        "habitforge <support@habitforge.com>"
    subject     "log errors"
    body        :founderrors => founderrors
  end
  def notify_support_donations_due(number_of_bets_due)  
    recipients  "jurowski@gmail.com"
    from        "habitforge <support@habitforge.com>"
    subject     "Donations Due?"
    body        :number_of_bets_due => number_of_bets_due
  end

  def notify_support_extraacc_due(number_of_extraacc_due)  
    recipients  "jurowski@gmail.com"
    from        "habitforge <support@habitforge.com>"
    subject     "Need to Email some people with Extra Accountability?"
    body        :number_of_extraacc_due => number_of_extraacc_due
  end



  #@stat.checkpointemailssent
  #@stat.totalheckpointemailfailure
  #@stat.goalcount
  #@stat.usercount
  #@stat.recorddate
  #@stat.recordhour  
  #Notifier.deliver_notify_support_stats(@stat) # sends the email
end
