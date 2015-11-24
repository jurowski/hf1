require 'active_record'
require 'date'
require 'logger'
class SeedEvents < ActiveRecord::Base
  # This script seeds events

  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/seed_events.rb

  ### RUN IN PRODUCTION:
  ### cd /habitforge/current;RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/update_promotion_black_friday_2014.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/seed_events.rb


    # event_type = Event_type.find(:all, :conditions => "name = 'email checkpoint same day'")
    # if !event_type
    #   event_type = Event_type.new()
    #   event_type.name = "email checkpoint same day"
    #   event_type.category = "email"
    #   event_type.disabled = false
    #   event_type.save
    # end

end
