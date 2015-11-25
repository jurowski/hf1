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

    event_type_string = "email checkpoint"
    event_type_id = 0
    event_type = EventType.find(:first, :conditions => "name = '#{event_type_string}'")
    if event_type
      event_type_id = event_type.id 
    else
      puts "ERROR event type not found for " + event_type_string
    end

    conditions = "event_type_id = '#{event_type_id}' and status = 'pending' and valid_at_datetime < '#{tnow}' and expire_at_datetime > '#{tnow}'"
    puts "conditions: " + conditions

    checkpoint_email_queue_items = EventQueues.find(:all, :conditions => conditions)

    checkpoint_email_queue_items.each do |checkpoint_email_queue_item|
      checkpoint = Checkpoint.find(checkpoint_email_queue_item.checkpoint_id)
      if checkpoint

        logtext = "sgj:about to email checkpoint email to " + checkpoint.goal.user.email
        puts logtext
        logger.info logtext 

        if Notifier.deliver_checkpoint_notification_sameday(checkpoint) # sends the email                                
          checkpoint_email_queue_item.status = "sent"

          logtext = "sent"
          puts logtext
          logger.info logtext 

        else
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
