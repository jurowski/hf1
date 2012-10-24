require 'active_record'
class FindErrorsInLog < ActiveRecord::Base

  # This script:
  # looks through the log for errors and emails when found

  founderrors = %x[grep 500.html /habitforge/current/log/production.log]
  #founderrors = %x[grep 500.html /Users/sgj700/Sites/svn_working_copy/trunk/log/development.log]
  
  Notifier.deliver_notify_support_error(founderrors) # sends the email  
  

  puts "end of script"

end
