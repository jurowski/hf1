require 'active_record'
require 'logger'


### make it easy to write output to the terminal + log at the same time
def output_me(level, print_and_log_me)

    print_and_log_me = "users_generate_handle.rb:" + print_and_log_me
    puts print_and_log_me

    if level == "debug"
        logger.debug(print_and_log_me)
    end
    if level == "info"
        logger.info(print_and_log_me)
    end
    if level == "error"
        logger.error(print_and_log_me)
    end
end

class UsersGenerateHandle < ActiveRecord::Base

  # This script generates and assignes handles for all users of the app who don't yet have one

  ### RUN IN PRODUCTION:
  ### cd /habitforge/current;RAILS_ENV=production /usr/bin/ruby /home/jurowsk1/etc/rails_apps/habitforge/current/script/runner /home/jurowsk1/etc/rails_apps/habitforge/current/app/users_generate_handle.rb
  #RAILS_ENV=production 
  #/usr/bin/ruby 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/script/runner 
  #/home/jurowsk1/etc/rails_apps/habitforge/current/app/users_generate_handle.rb

  ### RUN IN DEV:
  ### rvm use 1.8.7;cd /home/sgj700/rails_apps/hf1/;ruby script/runner app/users_generate_handle.rb


output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")
output_me("info", "--     USERS GENERATE HANDLE          --")
output_me("info", "--           START script             --")
output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")


max = 1000

users = User.find(:all, :limit => max, :conditions => "handle is null or handle = ''")
users.each do |user|
  user.assign_unique_handle
  output_me("info", user.first_name + " gets handle of " + user.handle)
end


output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")
output_me("info", "--     (USERS GENERATE HANDLE    )    --")
output_me("info", "--           END script               --")
output_me("info", "----------------------------------------")
output_me("info", "----------------------------------------")





end
