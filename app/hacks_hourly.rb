require 'active_record'
class HacksHourly < ActiveRecord::Base


  ### RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/hacks_hourly.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/hacks_hourly.rb


  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/hacks_hourly.rb

  # This script:
  # runs hacks that at some point need to be cleaned up in code



  ### fix Bill's March 11th entry to be a "yes"
  c = Checkpoint.find(:first, :conditions => "id = '5663905'")
  if c
    c.update_status("yes")
    c.save
    puts "saved status"
  else
    puts "could not find c"
  end



  puts "end of script"

end