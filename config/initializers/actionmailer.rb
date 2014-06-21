



if `uname -n`.strip == 'adv.adventurino.com'
  #### HABITFORGE SETTINGS ON VPS
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
      :address => "mail.habitforge.com",
      :port => 25,
      :domain => "habitforge.com",
      :user_name => "jurowsk1@habitforge.com",
      :password => "ZHabitforge1!",
      :authentication => :login
  
  }
elsif `uname -n`.strip == 'gns499aa.joyent.us'
  #### HABITFORGE SETTINGS ON VPS
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
      :address => "mail.habitforge.com",
      :port => 25,
      :domain => "habitforge.com",
      :user_name => "jurowsk1@habitforge.com",
      :password => "xxx",
      :authentication => :login

  }
else
  #### SETTINGS FOR DEV LAPTOP
  ActionMailer::Base.delivery_method = :sendmail
  ActionMailer::Base.sendmail_settings = { 
    :location       => '/usr/sbin/sendmail', 
    :arguments      => '-i -t'
  }
end





ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"