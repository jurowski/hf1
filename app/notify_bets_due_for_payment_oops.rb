require 'active_record'
require 'date'
require 'logger'

class NotifyBetsDueForPayment < ActiveRecord::Base

  # This script:
  # finds 30-day bets that are expired
  # and notifies admin via email so that donations can be made

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
  dyesterday = dnow - 1
  d2daysago = dnow - 2
  d30daysago = dnow - 30

  @bets_due = Bet.find(:all, :conditions => "end_date <= '#{d30daysago}' and sent_bill_notice_date = '2013-07-23'")
  if @bets_due.size > 0
      for bet in @bets_due

        bet_yes_percent = 0
        @checkpoints_bet = Checkpoint.find(:all, :conditions => "goal_id = '#{bet.goal.id}' and checkin_date >= '#{bet.start_date}' and checkin_date <= '#{bet.end_date}'")
        bet_checkpoints_size = @checkpoints_bet.size
        @checkpoints_yes = Checkpoint.find(:all, :conditions => "status = 'yes' and goal_id = '#{bet.goal.id}' and checkin_date >= '#{bet.start_date}' and checkin_date <= '#{bet.end_date}'")
        if bet_checkpoints_size > 0
            bet_yes_percent = (((@checkpoints_yes.size + 0.0) / bet_checkpoints_size)*100).floor 
            bet.success_rate = bet_yes_percent
            bet.save
        end

        ### Determine minimum days needed to succeed, and round up!
        floor_days = ((bet.floor + 0.0)/100) * bet.length_days
        floor_days_mod = floor_days.floor
        if floor_days > floor_days_mod
            floor_days = (floor_days_mod + 1)
        end
        @floor_days = floor_days.floor
        @successful_days = @checkpoints_yes.size

        @bet = bet
        @user = bet.user


        begin
          if bet.recipient_type == "random"
            Notifier.deliver_bet_fire_random_due_notification_to_user_oops(@user, @bet, @floor_days, @successful_days)
            Notifier.deliver_bet_fire_random_due_notification_to_recipient_oops(@user, @bet, @floor_days, @successful_days)
          end
          if bet.recipient_type == "charity"
            Notifier.deliver_bet_fire_charity_due_notification_oops(@user, @bet, @floor_days, @successful_days)
          end
          if bet.recipient_type == "friend"
            Notifier.deliver_bet_fire_friend_due_notification_oops(@user, @bet, @floor_days, @successful_days)
          end
        rescue
          logmessage = "sgj:error when sending bet due notice"
          logger.error(logmessage)
          bet.error_on_notification = logmessage
        end

        bet.sent_bill_notice_date = dnow
        bet.save
      end
      puts "#{@bets_due.size.to_s} bet resolution emails sent out on #{dnow.to_s}"
  else
      puts "no bets notifications sent out today"
  end
  
  puts "end of script"

end
