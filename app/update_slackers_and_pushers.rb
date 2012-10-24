require 'active_record'
require 'date'
require 'logger'

class UpdateSlackersAndPushers < ActiveRecord::Base

  # For those who asked for a "push", determine when their next push should come
  # When a pusher pushes a slacker and the slacker succeeds, notify the pusher


  ### GET DATE NOW ###
  jump_forward_days = 0
  
  tnow = Time.now
  tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
  tnow_m = tnow.strftime("%m").to_i #month of the year
  tnow_d = tnow.strftime("%d").to_i #day of the month
  tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
  tnow_M = tnow.strftime("%M").to_i #minute of the hour
  #puts tnow_Y + tnow_m + tnow_d  
  #puts "Current timestamp is #{tnow.to_s}"
  dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
  dyesterday = dnow - 1
  four_days_ago = dnow - 4
  ten_days_ago = dnow - 10
  ######


  ############################
  ### UPDATE SLACKER GOALS1 ###

  slacker_goal_counter = 0

  slacker_goal_conditions = "allow_push = 1"
  slacker_goal_conditions += " and (stop >= '#{dnow}' or stop = '1900-01-01')"

  puts "running query: " + slacker_goal_conditions

  slacker_goal = Goal.find(:all, :conditions => slacker_goal_conditions)
  slacker_goal.each do |slacker_goal|
    slacker_goal_counter += 1
    if !slacker_goal.pushes_allowed_per_day
      slacker_goal.pushes_allowed_per_day = 1
    end

    ##### Make sure that if someone is succeeding, they don't get bugged for  afew days
    if slacker_goal.next_push_on_or_after_date and slacker_goal.last_success_date and (slacker_goal.last_success_date > (slacker_goal.next_push_on_or_after_date - 3))
            slacker_goal.next_push_on_or_after_date = slacker_goal.last_success_date + 3
            slacker_goal.pushes_remaining_on_next_push_date = slacker_goal.pushes_allowed_per_day
    end

    slacker_goal.save
  end
  ### END UPDATE SLACKER GOALS1
  ############################## 

 
  ############################
  ### UPDATE SLACKER GOALS2 ###

  slacker_goal_counter = 0

  slacker_goal_conditions = "allow_push = 1"
  slacker_goal_conditions += " and (stop >= '#{dnow}' or stop = '1900-01-01')"
  slacker_goal_conditions += " and (last_success_date < '#{dnow - 3}' or (last_success_date is null and start <= '#{dnow - 2}') or (last_success_date is null and laststatusdate is not null))"
  
  puts "running query: " + slacker_goal_conditions

  slacker_goal = Goal.find(:all, :conditions => slacker_goal_conditions)
  slacker_goal.each do |slacker_goal|
    slacker_goal_counter += 1
    if !slacker_goal.pushes_allowed_per_day
      slacker_goal.pushes_allowed_per_day = 1
    end

    ##### Make sure that if someone is succeeding, they don't get bugged for  afew days
    if slacker_goal.next_push_on_or_after_date and slacker_goal.last_success_date and (slacker_goal.last_success_date > (slacker_goal.next_push_on_or_after_date - 3))
            slacker_goal.next_push_on_or_after_date = slacker_goal.last_success_date + 3
            slacker_goal.pushes_remaining_on_next_push_date = slacker_goal.pushes_allowed_per_day
    end

    if !slacker_goal.next_push_on_or_after_date or (slacker_goal.next_push_on_or_after_date < dnow)
      slacker_goal.next_push_on_or_after_date = dnow
      slacker_goal.pushes_remaining_on_next_push_date = slacker_goal.pushes_allowed_per_day
    else
      if slacker_goal.next_push_on_or_after_date == dnow
        if slacker_goal.pushes_remaining_on_next_push_date < 1
	  slacker_goal.next_push_on_or_after_date = (dnow + 1)
          slacker_goal.pushes_remaining_on_next_push_date = slacker_goal.pushes_allowed_per_day
	end
      end
    end
    puts "saving slacker_goal: " + slacker_goal_counter.to_s + ": " + slacker_goal.title
    slacker_goal.save
  end
  ### END UPDATE SLACKER GOALS
  ##############################


  ################################
  ### NOTIFY AND AWARD PUSHERS
  ### (do this in a cron instead of dynamically in checkpoint.save ... b/c of lack of DRY this is safer for now)
  ### check only for pushes from 3 days ago to allow for slacker to have checked in for the 2 valid days
  date_of_push = dnow - 3
  while date_of_push <= dnow

    pushers = User.find(:all, :conditions => "date_i_last_pushed_a_slacker = '#{date_of_push}'")
    pushers.each do |pusher|
      puts pusher.first_name + " pushed a slacker with goal_id of " + pusher.slacker_id_that_i_last_pushed.to_s + " on " + date_of_push.to_s
      goal = Goal.find(:first, :conditions => "id = #{pusher.slacker_id_that_i_last_pushed}")
      if !goal
        puts "....but that goal does not exist"
      else
        puts "....and that goal is held by " + goal.user.first_name
        puts "....and has a last success date of: "
        if goal.last_success_date
           puts goal.last_success_date.to_s
        else
           puts "NEVER"
        end
      end 
      if goal and (goal.last_success_date and ((goal.last_success_date == date_of_push) or (goal.last_success_date == (date_of_push + 1))))

        puts pusher.first_name + " helped " + goal.user.first_name + " with a push, and earned 10 SupportPoints!"

        pusher.supportpoints_log += "\nHey, you helped #{goal.user.first_name} succeed with the push you sent! You earned another 10 SupportPoints!"
        if !pusher.supportpoints
          pusher.supportpoints = 10
        else
          pusher.supportpoints += 10
        end

        ### reset so that we don't do this one again
        pusher.slacker_id_that_i_last_pushed = 0
        pusher.save
        begin
	  ###!!! send an email to the pusher saying "\nHey, you helped #{goal.user.first_name} succeed with the push you sent! You earned another 10 SupportPoints!"
          Notifier.deliver_succeeded_with_pushmessage_to_slacker(pusher, goal) # sends the email
        rescue
      	  puts "error sending email to " + pusher.email
        end		
      end
    end
    date_of_push += 1
  end
  ### END NOTIFY PUSHERS
  ###################################

  
  puts "end of script"

  

end
