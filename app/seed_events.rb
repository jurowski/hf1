require 'active_record'
require 'date'
require 'logger'
class SeedEvents < ActiveRecord::Base
  # This script seeds events

  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/seed_events.rb

  ### RUN IN PRODUCTION:
  ### cd /habitforge/current;RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/seed_events.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/seed_events.rb



    check_for = ["email checkpoint", "email checkpoint multiple", "email reminder"]

    check_for.each do |check|

      event_type = EventType.find(:first, :conditions => "name = '#{check}'")
      if !event_type
        event_type = EventType.new()
        event_type.name = check
        event_type.category = "email"
        event_type.disabled = false
        event_type.save
        puts "created " + check
      else
        puts "already  had " + check
      end

    end

end
