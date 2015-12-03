require 'active_record'
require 'date'
require 'logger'
class SendEmailCheckpointsFromQueue < ActiveRecord::Base
  # This script seeds events

  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/send_email_checkpoints.rb

  ### RUN IN PRODUCTION:
  ### cd /habitforge/current;RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/send_email_checkpoints.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/send_email_checkpoints.rb



    tnow = Time.now
    
    tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
    tnow_m = tnow.strftime("%m").to_i #month of the year
    tnow_d = tnow.strftime("%d").to_i #day of the month
    tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
    tnow_k = tnow.strftime("%k").to_i #hour (24-hour format, w/ no leading zeroes)
    tnow_M = tnow.strftime("%M").to_i #minute of the hour
    #puts tnow_Y + tnow_m + tnow_d  
    #puts "Current timestamp is #{tnow.to_s}"
    dnow = Date.new(tnow_Y, tnow_m, tnow_d)
    dyesterday = dnow - 1
    d2daysago = dnow - 2
    dtomorrow = dnow + 1
    dtomorrow_plus1 = dtomorrow + 1

    tservernow = tnow
    tservertomorrow = tnow + (24 * 3600)

    serverdnow = dnow
    serverdtomorrow = dnow + 1

    ######
    ###################
    ###################


    event_type_strings = ["email checkpoint", "email checkpoint multiple"]
    event_type_id = 0

    event_type_strings.each do |event_type_string|

      event_type = EventType.find(:first, :conditions => "name = '#{event_type_string}'")
      if event_type
        event_type_id = event_type.id 
      else
        puts "ERROR event type not found for " + event_type_string
      end

      conditions = "event_type_id = '#{event_type_id}' and status = 'pending' and valid_at_date = '#{serverdnow}'"
      puts "conditions: " + conditions

      checkpoint_email_queue_items = EventQueue.find(:all, :conditions => conditions)

      checkpoint_email_queue_items.each do |checkpoint_email_queue_item|
        checkpoint = Checkpoint.find(checkpoint_email_queue_item.checkpoint_id)
        if checkpoint

          logtext = "sgj:about to " + event_type_string + " email to " + checkpoint.goal.user.email
          puts logtext
          logger.info logtext 


          success = false
          if event_type_string == "email checkpoint sameday"
            if Notifier.deliver_checkpoint_notification_sameday(checkpoint) # sends the email                                
              checkpoint_email_queue_item.status = "sent"

              logtext = "sent"
              puts logtext
              logger.info logtext 

              success = true
            end
          end

          if event_type_string == "email checkpoint multiple sameday"
            if Notifier.deliver_checkpoint_notification_multiple_sameday(checkpoint) # sends the email                                
              checkpoint_email_queue_item.status = "sent"

              logtext = "sent"
              puts logtext
              logger.info logtext 
            end
          end

          if event_type_string == "email checkpoint nextday"
            if Notifier.deliver_checkpoint_notification(checkpoint) # sends the email                                
              checkpoint_email_queue_item.status = "sent"

              logtext = "sent"
              puts logtext
              logger.info logtext 

              success = true
            end
          end

          if event_type_string == "email checkpoint multiple nextday"
            if Notifier.deliver_checkpoint_notification_multiple(checkpoint) # sends the email                                
              checkpoint_email_queue_item.status = "sent"

              logtext = "sent"
              puts logtext
              logger.info logtext 
            end
          end


          if success == false
            checkpoint_email_queue_item.status = "failed to send"

            logtext = "failed to send"
            puts logtext
            logger.info logtext 
          end


        else
            checkpoint_email_queue_item.status = "failed to find checkpoint"

            logtext = "failed to find checkpoint"
            puts logtext
            logger.info logtext 

        end
        checkpoint_email_queue_item.save
      
        logtext = "moving to next queue item"
        puts logtext
        logger.info logtext 

      end

    end

end
