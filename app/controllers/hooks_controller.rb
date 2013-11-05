require 'rexml/document'
require 'date'
require 'geocoder'


class HooksController < ApplicationController
  protect_from_forgery :except => :create
  
  require 'logger'



  def new_rowley_user

    ### What comes back once they confirm
    # Processing HooksController#new_rowley_user (for 207.106.13.51 at 2013-11-04 16:49:54) [GET]
    # 2013-11-04 22:49:54 GMT | INFO | 22818 |   Parameters: {"contact_name"=>"Sandon", "ACCOUNT_ID"=>"dqcM", "action"=>"new_rowley_user", "account_login"=>"johnrowley", "CONTACT_ID"=>"Aham3", "campaign_name"=>"52_million_pound_challenge", "contact_ip"=>"144.92.221.139", "contact_origin"=>"www", "controller"=>"hooks", "contact_email"=>"support%40habitforge.com", "CAMPAIGN_ID"=>"7bjl"}
    # 2013-11-04 22:49:54 GMT | INFO | 22818 | Completed in 1ms (View: 0, DB: 0) | 200 OK [http://habitforge.com/hooks/rowley_52m/new_rowley_user?CONTACT_ID=Aham3&ACCOUNT_ID=dqcM&account_login=johnrowley&contact_name=Sandon&campaign_name=52_million_pound_challenge&contact_ip=144.92.221.139&CAMPAIGN_ID=7bjl&contact_email=support%2540habitforge.com&contact_origin=www&action=subscribe]
    # 2013-11-04 22:50:03 GMT | INFO | 22818 | 

    #ex: http://habitforge.com/hooks/rowley_52m/new_rowley_user?CONTACT_ID=AhaCe&ACCOUNT_ID=dqcM&account_login=johnrowley&contact_name=SJ&campaign_name=52_million_pound_challenge&contact_ip=144.92.221.130&CAMPAIGN_ID=7bjl&contact_email=jurowski%2540wisc.edu&contact_origin=www&action=subscribe
    # "contact_name"=>"Sandon", 
    # "ACCOUNT_ID"=>"dqcM", 
    # "action"=>"new_rowley_user", 
    # "account_login"=>"johnrowley", 
    # "CONTACT_ID"=>"Aham3", 
    # "campaign_name"=>"52_million_pound_challenge", 
    # "contact_ip"=>"144.92.221.139", 
    # "contact_origin"=>"www", 
    # "controller"=>"hooks", 
    # "contact_email"=>"support%40habitforge.com", 
    # "CAMPAIGN_ID"=>"7bjl"


    if params[:contact_email] and params[:contact_ip] and params[:contact_name] and params[:campaign_name] and params[:campaign_name] == "52_million_pound_challenge"
      logger.info("sgj:52m_new_users:ROWLEY NEW SIGNUP:email=" + params[:contact_email] + ":name=" + params[:contact_name] + ":IP=" + params[:contact_ip] )

      params_email = params[:contact_email].gsub('%40', "@")

      @user_already_exists = false
      user = User.find(:first, :conditions => "email = '#{params_email}'") 
      if user
        ### sorry, there's already an HF account with that email address
        logger.info("sgj:52m_new_users:USER ALREADY EXISTS WITH email=" + params_email)
        @user_already_exists = true
      end


      if !@user_already_exists
        logger.info("sgj:52m_new_users:ATTEMPT NEW USER CREATION WITH email=" + params_email)
        user = User.new
        user.first_name = params[:contact_name].gsub('%20', " ")
        user.last_name = ""
        user.email = params_email
        user.email_confirmation = user.email
        random_pw_number = rand(1000) + 1 #between 1 and 1000
        user.password = "xty" + random_pw_number.to_s
        user.password_confirmation = user.password
        user.password_temp = user.password
        user.sponsor = "habitforge"
        user.time_zone = "Central Time (US & Canada)"
        ### having periods in the first name kills the attempts to email that person, so remove periods
        user.first_name = user.first_name.gsub(".", "")
        ### Setting this to something other than 0 so that this person
        ### is included in the next morning's cron job to send emails
        ### this will get reset to the right number once each day via cron
        ### but set it now in case user is being created after that job runs
        user.update_number_active_goals = 1


        if user.save



          begin
            logger.info("sgj:52m_new_users:ATTEMPT GEOLOOKUP FOR new user email=" + user.email)
            s = Geocoder.search(params[:contact_ip])
            user.state_code = s[0].state_code
            user.country_code = s[0].country_code
            user.country = s[0].country

            if user.country_code == "US"
              user.country = "usa"
            end

            if user.country_code == "CA"
              user.country = "canada"
            end

            logger.info("sgj:52m_new_users:INFO FROM GEOLOOKUP FOR new user email=" + user.email + "... state_code=" + user.state_code + ":country=" + user.country + ":country_code=" + user.country_code)
          rescue
            logger.info("sgj:52m_new_users:FAILURE DURING GEOLOOKUP FOR new user email=" + user.email)
          end


          ### update last activity date
          user.last_activity_date = user.dtoday

          user.date_of_signup = user.dtoday
          #user.confirmed_address = true ### since user via rowley getresponse already confirmed


          #stats_increment_new_user## not available in hook
          logger.info("sgj:52m_new_users:SUCCESS SAVING new user email=" + user.email)

          begin
            logger.info("sgj:52m_new_users:ATTEMPT TO SEND USER CONF EMAIL FOR new user email=" + user.email)
            #### ALLOW FOR EMAIL ADDRESS CONFIRMATION
            random_confirm_token = rand(1000) + 1 #between 1 and 1000
            user.confirmed_address_token = "xtynzsc" + random_confirm_token.to_s
            user.save
            #### now that we have saved and have the user id, we can send the email 
            the_subject = "Confirm your HabitForge Subscription"
            Notifier.deliver_user_confirm(user, the_subject) # sends the email
          rescue
            logger.info("sgj:52m_new_users:FAILURE SENDING USER CONF EMAIL FOR new user email=" + user.email)
          end


          begin
            logger.info("sgj:52m_new_users:will try creating an infusionsoft contact for user with email " + user.email)
            #400: hf new signup funnel v2 free no goal yet
            #398: hf new signup funnel v2 free created goal
            new_contact_id = Infusionsoft.contact_add({:FirstName => user.first_name, :LastName => user.last_name, :Email => user.email})
            Infusionsoft.email_optin(user.email, 'HabitForge signup')
            Infusionsoft.contact_add_to_group(new_contact_id, 400)
             logger.info("sgj:52m_new_users:SUCCESS creating an infusionsoft contact with new_contact_id=" + new_contact_id.to_s + " for user with email " + user.email)
          rescue
            logger.info("sgj:52m_new_users:ERROR creating an infusionsoft contact for user with email " + user.email)
          end



          begin

            logger.info("sgj:52m_new_users:will try adding to infusionsoft followup funnel sequence the infusionsoft_contact_id: " + new_contact_id.to_s + " for user with email " + user.email)

            url = "https://sdc90018.infusionsoft.com/api/xmlrpc"
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true if (uri.scheme == 'https')
            data = "<?xml version='1.0' encoding='UTF-8'?>\
            <methodCall>\
            <methodName>FunnelService.achieveGoal</methodName>\
            <params>\
            <param><value><string>d541e86effd15eb57f1f9f6344fc8eee</string></value></param>\
            <param><value><string>sdc90018</string></value></param>\
            <param><value><string>HabitForgeFollowUp</string></value></param>\
            <param><value><int>#{new_contact_id}</int></value></param>\
            </params>\
            </methodCall>"
            headers = {'Content-Type' => 'text/xml'}
            # warning, uri.path will drop queries, use uri.path + uri.query if you need to
            resp, body = http.post(uri.path, data, headers)

            logger.info("sgj:52m_new_users:xml response from adding new person with email " + user.email + " to infusionsoft sequence: " + resp.to_s + body.to_s)

          rescue
            logger.error("sgj:52m_new_users:error adding " + user.email + " to infusionsoft followup funnel sequence")
          end


          logger.info("sgj:52m_new_users:NOW CREATE GOAL FOR NEW USER")

          ##########################
          #### START CREATE GOAL FOR NEW USER
          ##########################
          ##########################
          @goal = Goal.new

          @goal.user = user

          @goal.tracker_set_checkpoint_to_yes_if_any_answer = false # the db default is true, but false is better
          @goal.tracker_set_checkpoint_to_yes_only_if_answer_acceptable = false # the db default is true, but false is safer for now

          @goal.reminder_time = DateTime.new(2009,1,1,0,0,0)

          @goal.reminder_send_hour = 8 #### 8am
          @goal.usersendhour = 20 ### 8pm

          @goal.daym = 1
          @goal.dayt = 1
          @goal.dayw = 1
          @goal.dayr = 1
          @goal.dayf = 1
          @goal.days = 1
          @goal.dayn = 1

          @goal.more_reminders_enabled = false
          @goal.more_reminders_start = 8
          @goal.more_reminders_end = 22
          @goal.more_reminders_every_n_hours = 4
          @goal.more_reminders_last_sent = 0


          @goal.publish = 1

          @goal.title = "eating healthy"
          @goal.response_question = @goal.title

          @goal.category = "Diet, Healthy Foods and Water"

          ### PROGRAM ID = 4 (for John Rowley's 52 Milion Pound Challenge)
          @goal.goal_added_through_template_from_program_id = 4

          ### TEMPLATE ID = 143092 (the "Eat Healthy!" one)
          template_user_parent_goal_id = 143092 

          @goal.template_user_parent_goal_id = template_user_parent_goal_id

          template_user_parent_goal = Goal.find(template_user_parent_goal_id)
          if template_user_parent_goal
            @goal.template_user_parent_goal_id = template_user_parent_goal.id
            @goal.title = template_user_parent_goal.title
            @goal.response_question = template_user_parent_goal.response_question
            @goal.category = template_user_parent_goal.category
            @goal.reminder_time = template_user_parent_goal.reminder_time
            @goal.daym = template_user_parent_goal.daym
            @goal.dayt = template_user_parent_goal.dayt
            @goal.dayw = template_user_parent_goal.dayw
            @goal.dayr = template_user_parent_goal.dayr
            @goal.dayf = template_user_parent_goal.dayf
            @goal.days = template_user_parent_goal.days
            @goal.dayn = template_user_parent_goal.dayn
            @goal.goal_days_per_week = template_user_parent_goal.goal_days_per_week
            @goal.remind_me = template_user_parent_goal.remind_me
            @goal.reminder_send_hour = template_user_parent_goal.reminder_send_hour
            @goal.check_in_same_day = template_user_parent_goal.check_in_same_day
            @goal.usersendhour = template_user_parent_goal.usersendhour


            if template_user_parent_goal.tracker != nil
            @goal.tracker = template_user_parent_goal.tracker
            end
            if template_user_parent_goal.tracker_question != nil
            @goal.tracker_question = template_user_parent_goal.tracker_question
            end
            if template_user_parent_goal.tracker_statement != nil
            @goal.tracker_statement = template_user_parent_goal.tracker_statement
            end
            if template_user_parent_goal.tracker_units != nil
            @goal.tracker_units = template_user_parent_goal.tracker_units
            end
            if template_user_parent_goal.tracker_digits_after_decimal != nil
            @goal.tracker_digits_after_decimal = template_user_parent_goal.tracker_digits_after_decimal
            end
            if template_user_parent_goal.tracker_standard_deviation_from_last_measurement != nil
            @goal.tracker_standard_deviation_from_last_measurement = template_user_parent_goal.tracker_standard_deviation_from_last_measurement
            end
            if template_user_parent_goal.tracker_type_starts_at_zero_daily != nil
            @goal.tracker_type_starts_at_zero_daily = template_user_parent_goal.tracker_type_starts_at_zero_daily
            end
            if template_user_parent_goal.tracker_target_higher_value_is_better != nil
            @goal.tracker_target_higher_value_is_better = template_user_parent_goal.tracker_target_higher_value_is_better
            end
            if template_user_parent_goal.tracker_set_checkpoint_to_yes_if_any_answer != nil
            @goal.tracker_set_checkpoint_to_yes_if_any_answer = template_user_parent_goal.tracker_set_checkpoint_to_yes_if_any_answer
            end
            if template_user_parent_goal.tracker_set_checkpoint_to_yes_only_if_answer_acceptable != nil
            @goal.tracker_set_checkpoint_to_yes_only_if_answer_acceptable = template_user_parent_goal.tracker_set_checkpoint_to_yes_only_if_answer_acceptable
            end
            if template_user_parent_goal.tracker_target_threshold_bad1 != nil
            @goal.tracker_target_threshold_bad1 = template_user_parent_goal.tracker_target_threshold_bad1
            end
            if template_user_parent_goal.tracker_target_threshold_bad2 != nil
            @goal.tracker_target_threshold_bad2 = template_user_parent_goal.tracker_target_threshold_bad2
            end
            if template_user_parent_goal.tracker_target_threshold_bad3 != nil
            @goal.tracker_target_threshold_bad3 = template_user_parent_goal.tracker_target_threshold_bad3
            end
            if template_user_parent_goal.tracker_target_threshold_good1 != nil
            @goal.tracker_target_threshold_good1 = template_user_parent_goal.tracker_target_threshold_good1
            end
            if template_user_parent_goal.tracker_target_threshold_good2 != nil
            @goal.tracker_target_threshold_good2 = template_user_parent_goal.tracker_target_threshold_good2
            end
            if template_user_parent_goal.tracker_target_threshold_good3 != nil
            @goal.tracker_target_threshold_good3 = template_user_parent_goal.tracker_target_threshold_good3
            end
            if template_user_parent_goal.tracker_measurement_worst_yet != nil
            @goal.tracker_measurement_worst_yet = template_user_parent_goal.tracker_measurement_worst_yet
            end
            if template_user_parent_goal.tracker_measurement_best_yet != nil
            @goal.tracker_measurement_best_yet = template_user_parent_goal.tracker_measurement_best_yet
            end
            if template_user_parent_goal.tracker_measurement_last_taken_on_date != nil
            @goal.tracker_measurement_last_taken_on_date = template_user_parent_goal.tracker_measurement_last_taken_on_date
            end
            if template_user_parent_goal.tracker_measurement_last_taken_on_hour != nil
            @goal.tracker_measurement_last_taken_on_hour = template_user_parent_goal.tracker_measurement_last_taken_on_hour
            end
            if template_user_parent_goal.tracker_measurement_last_taken_value != nil
            @goal.tracker_measurement_last_taken_value = template_user_parent_goal.tracker_measurement_last_taken_value
            end
            if template_user_parent_goal.tracker_measurement_last_taken_timestamp != nil
            @goal.tracker_measurement_last_taken_timestamp = template_user_parent_goal.tracker_measurement_last_taken_timestamp
            end
            if template_user_parent_goal.tracker_prompt_after_n_days_without_entry != nil
            @goal.tracker_prompt_after_n_days_without_entry = template_user_parent_goal.tracker_prompt_after_n_days_without_entry
            end
            if template_user_parent_goal.tracker_prompt_for_an_initial_value != nil
            @goal.tracker_prompt_for_an_initial_value = template_user_parent_goal.tracker_prompt_for_an_initial_value
            end
            if template_user_parent_goal.tracker_track_difference_between_initial_and_latest != nil
            @goal.tracker_track_difference_between_initial_and_latest = template_user_parent_goal.tracker_track_difference_between_initial_and_latest
            end
            if template_user_parent_goal.tracker_difference_between_initial_and_latest != nil
            @goal.tracker_difference_between_initial_and_latest = template_user_parent_goal.tracker_difference_between_initial_and_latest
            end
          end


          @goal.title = @goal.response_question
          @goal.pushes_allowed_per_day = 1

          ### update last activity date
          @goal.user.last_activity_date = @goal.user.dtoday
          @goal.user.save


          Time.zone = @goal.user.time_zone
          utcoffset = Time.zone.formatted_offset(false)
          offset_seconds = Time.zone.now.gmt_offset 
          send_time = Time.utc(2000, "jan", 1, @goal.usersendhour, 0, 0) #2000-01-01 01:00:00 UTC
          central_time_offset = 21600 #add this in since we're doing UTC
          server_time = send_time - offset_seconds - central_time_offset
          @goal.serversendhour = server_time.strftime('%k')
          @goal.gmtoffset = utcoffset          
          #############

          @goal.status = "start"

        
          @goal.established_on = Date.new(1900, 1, 1)

          @goal.days_to_form_a_habit = 21

          start_day_offset = 1
          @goal.start = @goal.user.dtoday + start_day_offset
          @goal.stop = @goal.start + @goal.days_to_form_a_habit
          @goal.first_start_date = @goal.start          

          if @goal.save
            logger.info("sgj:52m_new_users:SUCCESS SAVING 52M GOAL FOR new user email=" + user.email)            

            begin
              logger.info("sgj:52m_new_users:ATTEMPT UPDATING INFUSIONSOFT CONTACT FOR new user email=" + user.email)            
              ### PRODUCTION GROUP/TAG IDS
              #400: hf new signup funnel v2 free no goal yet
              #398: hf new signup funnel v2 free created goal

              Infusionsoft.contact_update(new_contact_id, {:FirstName => user.first_name, :LastName => user.last_name})
              Infusionsoft.contact_add_to_group(new_contact_id, 398)
              Infusionsoft.contact_remove_from_group(new_contact_id, 400)
              ####          END INFUSIONSOFT CONTACT           ####
              logger.info("sgj:52m_new_users:SUCCESS UPDATING INFUSIONSOFT CONTACT FOR new user email=" + user.email)            
            rescue
              logger.info("sgj:52m_new_users:FAILURE UPDATING INFUSIONSOFT CONTACT FOR new user email=" + user.email)            
            end


            begin              
              Notifier.deliver_goal_creation_notification(@goal) # sends the email
              logger.info("sgj:52m_new_users:SENT GOAL CREATION NOTIFICATION EMAIL to new user email=" + user.email)            
            rescue
              logger.info("sgj:52m_new_users:ERROR SENDING GOAL CREATION NOTIFICATION EMAIL to new user email=" + user.email)            
            end




            begin 
              logger.info("sgj:52m_new_users:ATTEMPT TO ADD TO ENCOURAGE TIMELINE for new user email=" + user.email)            
              ### attempt to add to encourage_items


              # when a goal is created,
              # if username != unknown,
              # if the goal is public,
              # then enter it into encourage_items

              # --- encourage_item ---
              # encourage_type_new_checkpoint_bool (index)
              # encourage_type_new_goal_bool (index)
              # checkpoint_id
              # checkpoint_status
              # checkpoint_date (index)
              # checkpoint_updated_at_datetime
              # goal_id (index)
              # goal_name
              # goal_category
              # goal_created_at_datetime
              # goal_publish
              # goal_first_start_date (index)
              # goal_daysstraight
              # goal_days_into_it
              # goal_success_rate_percentage
              # user_id (index)
              # user_name
              # user_email

              logger.debug "sgj:goals_controller.rb:consider adding to encourage_items"
              if @goal.user.first_name != "unknown"
                if @goal.is_public
                  logger.debug "sgj:goals_controller.rb:candidate for encourage_items"

                  encourage_item = EncourageItem.new
                  logger.debug "sgj:goals_controller.rb:new encourage_items instantiated"

                  encourage_item.encourage_type_new_checkpoint_bool = false
                  encourage_item.encourage_type_new_goal_bool = true

                  #encourage_item.checkpoint_id = nil
                  encourage_item.checkpoint_id = @goal.id ### a workaround to the validation that checkpoint_id is unique

                  encourage_item.checkpoint_status = nil
                  encourage_item.checkpoint_date = nil
                  encourage_item.checkpoint_updated_at_datetime = nil
                  encourage_item.goal_id = @goal.id
                  encourage_item.goal_name = @goal.title
                  encourage_item.goal_category = @goal.category
                  encourage_item.goal_created_at_datetime = @goal.created_at
                  encourage_item.goal_publish = @goal.publish
                  encourage_item.goal_first_start_date = @goal.first_start_date
                  encourage_item.goal_daysstraight = @goal.daysstraight
                  encourage_item.goal_days_into_it = @goal.days_into_it
                  encourage_item.goal_success_rate_percentage = @goal.success_rate_percentage
                  encourage_item.user_id = @goal.user.id
                  encourage_item.user_name = @goal.user.first_name
                  encourage_item.user_email = @goal.user.email



                  if encourage_item.save
                    logger.info("sgj:52m_new_users:SUCCESS ADDING TO ENCOURAGE TIMELINE for new user email=" + user.email)            
                    # logger.info("sgj:goals_controller.rb:success saving encourage_item")
                  else
                    # logger.error("sgj:goals_controller.rb:error saving encourage_item")
                    logger.info("sgj:52m_new_users:FAILURE ADDING TO ENCOURAGE TIMELINE for new user email=" + user.email)            
                  end
                  # logger.debug "sgj:goals_controller.rb:new encourage_item.id = " + encourage_item.id.to_s

                end
              end

            rescue
              logger.info("sgj:52m_new_users:ERROR WHILE ADDING TO ENCOURAGE TIMELINE for new user email=" + user.email)            
            end

          else
            logger.info("sgj:52m_new_users:FAILURE SAVING 52M GOAL FOR new user email=" + user.email)            
          end



          ##########################
          #### END CREATE GOAL FOR NEW USER
          ##########################
          ##########################


        else
          ### error saving user
          logger.info("sgj:52m_new_users:FAILURE DURING USER SAVE FOR new user email=" + params[:contact_email])
        end



      end

      #`cat "#{params[:email]},#{params[:name]},#{params[:country]},#{params[:state]}" >> 52m_new_users.csv`
      #`cat hello >> 52m_new_users.csv`
    end
    render :nothing => true
  end

  def create
    #Default to return 403 Forbidden
    status = 403

    logger.info 'xml SGJ starting to process hooks:create'


    #Check that the webhook is coming from your store

    ###COMMENT OUT THE NEXT LINE WHEN TESTING LOCALLY
    ###UNCOMMENT THE NEXT LINE IN PRODUCTION    
    logger.info 'xml SGJ does shopify shop domain =  habitforge.myshopify.com?'    
    logger.info 'xml SGJ HTTP_X_SHOPIFY_SHOP_DOMAIN = ' + request.headers["HTTP_X_SHOPIFY_SHOP_DOMAIN"].to_s

    ### HTTP_X_SHOPIFY_SHOP_ID now depracated ... use HTTP_X_SHOPIFY_SHOP_DOMAIN instead 
    ### https://groups.google.com/group/shopify-api/browse_thread/thread/43c939d83dd155ce?pli=1
    ###if request.headers["HTTP_X_SHOPIFY_SHOP_ID"] == '673792'

    #if request.headers["HTTP_X_SHOPIFY_SHOP_DOMAIN"] == 'habitforge.myshopify.com'
    #    logger.info 'xml SGJ YES, shopify shop domain =  habitforge.myshopify.com'
    if 1 == 1 ### using infusionsoft, protect this in some other way
      #Parse the XML
      begin
        logger.info 'xml SGJ starting parse xml'

testing_xml_user_upgrade_diff_email = %{
<order>
  <number type='integer'>249</number>
  <name>#1249</name>
  <created-at type='datetime'>2011-04-30T19:24:33-04:00</created-at>
  <total-discounts type='decimal'>0.0</total-discounts>
  <cancel-reason nil='true'/>
  <token>5f80f19bd58ca92c2fd19e9d152190c0</token>
  <updated-at type='datetime'>2011-04-30T19:24:45-04:00</updated-at>
  <total-price type='decimal'>9.99</total-price>
  <landing-site>/collections/frontpage/products/habitforge-supporting-membership-1-year?ref=44</landing-site>
  <taxes-included type='boolean'>false</taxes-included>
  <cancelled-at type='datetime' nil='true'/>
  <id type='integer'>61986342</id>
  <referring-site>http://habitforge.com/goals/new</referring-site>
  <total-line-items-price type='decimal'>9.99</total-line-items-price>
  <subtotal-price type='decimal'>9.99</subtotal-price>
  <note nil='true'/>
  <gateway>paypal</gateway>
  <fulfillment-status nil='true'/>
  <financial-status>paid</financial-status>
  <currency>USD</currency>
  <closed-at type='datetime' nil='true'/>
  <buyer-accepts-marketing type='boolean'>false</buyer-accepts-marketing>
  <total-tax type='decimal'>0.0</total-tax>
  <total-weight type='integer'>0</total-weight>
  <email>not-jurowski@gmail.com</email>
  <browser-ip>127.0.0.1</browser-ip>
  <landing-site-ref>44</landing-site-ref>
  <order-number type='integer'>1249</order-number>
  <shipping-address>
    <company>france menk photography</company>
    <city>Gardiner</city>
    <address1>2997B Route 44/55</address1>
    <latitude type='decimal'>41.715213</latitude>
    <zip>12525</zip>
    <address2>right side porch down hill</address2>
    <country>United States</country>
    <phone nil='true'/>
    <last-name>photography</last-name>
    <longitude type='decimal'>-74.198334</longitude>
    <province>New York</province>
    <first-name>france menk</first-name>
    <name>france menk photography</name>
    <country-code>US</country-code>
    <province-code>NY</province-code>
  </shipping-address>
  <tax-lines type='array'/>
  <line-items type='array'>
    <line-item>
      <price type='decimal'>9.99</price>
      <product-id type='integer'>33131182</product-id>
      <title>12 Month Supporting Membership</title>
      <quantity type='integer'>1</quantity>
      <requires-shipping type='boolean'>false</requires-shipping>
      <id type='integer'>102562172</id>
      <grams type='integer'>0</grams>
      <sku/>
      <fulfillment-status nil='true'/>
      <variant-title nil='true'/>
      <vendor>HabitForge</vendor>
      <fulfillment-service>manual</fulfillment-service>
      <variant-id type='integer'>78120792</variant-id>
      <name>12 Month Supporting Membership</name>
    </line-item>
  </line-items>
  <customer>
    <accepts-marketing type='boolean'>false</accepts-marketing>
    <orders-count type='integer'>1</orders-count>
    <id type='integer'>42546722</id>
    <note nil='true'/>
    <last-name>photography</last-name>
    <total-spent type='decimal'>9.99</total-spent>
    <first-name>france menk</first-name>
    <email>iam@france-menk.com</email>
    <tags/>
  </customer>
  <billing-address>
    <company>france menk photography</company>
    <city>Gardiner</city>
    <address1>2997B Route 44/55</address1>
    <latitude type='decimal'>41.715213</latitude>
    <zip>12525</zip>
    <address2>right side porch down hill</address2>
    <country>United States</country>
    <phone nil='true'/>
    <last-name>photography</last-name>
    <longitude type='decimal'>-74.198334</longitude>
    <province>New York</province>
    <first-name>france menk</first-name>
    <name>france menk photography</name>
    <country-code>US</country-code>
    <province-code>NY</province-code>
  </billing-address>
  <shipping-lines type='array'/>
  <note-attributes type='array'>
  </note-attributes>
</order>          
}

  
  

testing_xml_cause_diff_email_ref_came_through_true = %{
<order>
  <number type='integer'>254</number>
  <name>#1254</name>
  <created-at type='datetime'>2011-05-02T10:54:14-04:00</created-at>
  <total-discounts type='decimal'>0.0</total-discounts>
  <cancel-reason nil='true'/>
  <token>26aa9b5ddbe1c260c8b5298295a7c58a</token>
  <updated-at type='datetime'>2011-05-02T10:54:33-04:00</updated-at>
  <total-price type='decimal'>1.0</total-price>
  <landing-site>/</landing-site>
  <taxes-included type='boolean'>false</taxes-included>
  <cancelled-at type='datetime' nil='true'/>
  <id type='integer'>62169282</id>
  <referring-site/>
  <total-line-items-price type='decimal'>1.0</total-line-items-price>
  <subtotal-price type='decimal'>1.0</subtotal-price>
  <note nil='true'/>
  <gateway>paypal</gateway>
  <fulfillment-status nil='true'/>
  <financial-status>paid</financial-status>
  <currency>USD</currency>
  <closed-at type='datetime' nil='true'/>
  <buyer-accepts-marketing type='boolean'>false</buyer-accepts-marketing>
  <total-tax type='decimal'>0.0</total-tax>
  <total-weight type='integer'>0</total-weight>
  <email>jurowski@wisc.edu</email>
  <browser-ip>96.41.228.193</browser-ip>
  <landing-site-ref>t-cause_u-44_g-23620</landing-site-ref>
  <order-number type='integer'>1254</order-number>
  <shipping-address>
    <company nil='true'/>
    <city>Madison</city>
    <address1>37 Harwood Circle N</address1>
    <latitude type='decimal'>43.07141</latitude>
    <zip>53717</zip>
    <address2 nil='true'/>
    <country>United States</country>
    <phone nil='true'/>
    <last-name>Jurowski</last-name>
    <longitude type='decimal'>-89.508609</longitude>
    <province>Wisconsin</province>
    <first-name>Sandon</first-name>
    <name>Sandon Jurowski</name>
    <country-code>US</country-code>
    <province-code>WI</province-code>
  </shipping-address>
  <tax-lines type='array'>
    <tax-line>
      <price type='decimal'>0.0</price>
      <title>State Tax</title>
      <rate type='float'>0.05</rate>
    </tax-line>
  </tax-lines>
  <line-items type='array'>
    <line-item>
      <price type='decimal'>1.0</price>
      <product-id type='integer'>39685352</product-id>
      <title>American Red Cross: Cause Credits ($10 increments)</title>
      <quantity type='integer'>1</quantity>
      <requires-shipping type='boolean'>false</requires-shipping>
      <id type='integer'>102887392</id>
      <grams type='integer'>0</grams>
      <sku>Cause Credits (10)</sku>
      <fulfillment-status nil='true'/>
      <variant-title nil='true'/>
      <vendor>HabitForge</vendor>
      <fulfillment-service>manual</fulfillment-service>
      <variant-id type='integer'>91473642</variant-id>
      <name>American Red Cross: Cause Credits ($10 increments)</name>
    </line-item>
  </line-items>
  <customer>
    <accepts-marketing type='boolean'>false</accepts-marketing>
    <orders-count type='integer'>1</orders-count>
    <id type='integer'>42665082</id>
    <note nil='true'/>
    <last-name>Jurowski</last-name>
    <total-spent type='decimal'>1.0</total-spent>
    <first-name>Sandon</first-name>
    <email>jurowski@wisc.edu</email>
    <tags/>
  </customer>
  <billing-address>
    <company nil='true'/>
    <city>Madison</city>
    <address1>37 Harwood Circle N</address1>
    <latitude type='decimal'>43.07141</latitude>
    <zip>53717</zip>
    <address2 nil='true'/>
    <country>United States</country>
    <phone nil='true'/>
    <last-name>Jurowski</last-name>
    <longitude type='decimal'>-89.508609</longitude>
    <province>Wisconsin</province>
    <first-name>Sandon</first-name>
    <name>Sandon Jurowski</name>
    <country-code>US</country-code>
    <province-code>WI</province-code>
  </billing-address>
  <shipping-lines type='array'/>
  <note-attributes type='array'>
  </note-attributes>
</order>
}



testing_xml_cause_diff_email_ref_came_through_false = %{
<order>
  <number type='integer'>254</number>
  <name>#1254</name>
  <created-at type='datetime'>2011-05-02T10:54:14-04:00</created-at>
  <total-discounts type='decimal'>0.0</total-discounts>
  <cancel-reason nil='true'/>
  <token>26aa9b5ddbe1c260c8b5298295a7c58a</token>
  <updated-at type='datetime'>2011-05-02T10:54:33-04:00</updated-at>
  <total-price type='decimal'>1.0</total-price>
  <landing-site>/</landing-site>
  <taxes-included type='boolean'>false</taxes-included>
  <cancelled-at type='datetime' nil='true'/>
  <id type='integer'>62169282</id>
  <referring-site/>
  <total-line-items-price type='decimal'>1.0</total-line-items-price>
  <subtotal-price type='decimal'>1.0</subtotal-price>
  <note nil='true'/>
  <gateway>paypal</gateway>
  <fulfillment-status nil='true'/>
  <financial-status>paid</financial-status>
  <currency>USD</currency>
  <closed-at type='datetime' nil='true'/>
  <buyer-accepts-marketing type='boolean'>false</buyer-accepts-marketing>
  <total-tax type='decimal'>0.0</total-tax>
  <total-weight type='integer'>0</total-weight>
  <email>jimmy@gg.com</email>
  <browser-ip>96.41.228.193</browser-ip>
  <landing-site-ref nil='true'/>
  <order-number type='integer'>1254</order-number>
  <shipping-address>
    <company nil='true'/>
    <city>Madison</city>
    <address1>37 Harwood Circle N</address1>
    <latitude type='decimal'>43.07141</latitude>
    <zip>53717</zip>
    <address2 nil='true'/>
    <country>United States</country>
    <phone nil='true'/>
    <last-name>Jurowski</last-name>
    <longitude type='decimal'>-89.508609</longitude>
    <province>Wisconsin</province>
    <first-name>Sandon</first-name>
    <name>Sandon Jurowski</name>
    <country-code>US</country-code>
    <province-code>WI</province-code>
  </shipping-address>
  <tax-lines type='array'>
    <tax-line>
      <price type='decimal'>0.0</price>
      <title>State Tax</title>
      <rate type='float'>0.05</rate>
    </tax-line>
  </tax-lines>
  <line-items type='array'>
    <line-item>
      <price type='decimal'>1.0</price>
      <product-id type='integer'>39685352</product-id>
      <title>American Red Cross: Cause Credits ($10 increments)</title>
      <quantity type='integer'>1</quantity>
      <requires-shipping type='boolean'>false</requires-shipping>
      <id type='integer'>102887392</id>
      <grams type='integer'>0</grams>
      <sku>Cause Credits (10)</sku>
      <fulfillment-status nil='true'/>
      <variant-title nil='true'/>
      <vendor>HabitForge</vendor>
      <fulfillment-service>manual</fulfillment-service>
      <variant-id type='integer'>91473642</variant-id>
      <name>American Red Cross: Cause Credits ($10 increments)</name>
    </line-item>
  </line-items>
  <customer>
    <accepts-marketing type='boolean'>false</accepts-marketing>
    <orders-count type='integer'>1</orders-count>
    <id type='integer'>42665082</id>
    <note nil='true'/>
    <last-name>Jurowski</last-name>
    <total-spent type='decimal'>1.0</total-spent>
    <first-name>Sandon</first-name>
    <email>jimmy@gg.com</email>
    <tags/>
  </customer>
  <billing-address>
    <company nil='true'/>
    <city>Madison</city>
    <address1>37 Harwood Circle N</address1>
    <latitude type='decimal'>43.07141</latitude>
    <zip>53717</zip>
    <address2 nil='true'/>
    <country>United States</country>
    <phone nil='true'/>
    <last-name>Jurowski</last-name>
    <longitude type='decimal'>-89.508609</longitude>
    <province>Wisconsin</province>
    <first-name>Sandon</first-name>
    <name>Sandon Jurowski</name>
    <country-code>US</country-code>
    <province-code>WI</province-code>
  </billing-address>
  <shipping-lines type='array'/>
  <note-attributes type='array'>
  </note-attributes>
</order>
}




testing_xml_resend_any = %{
<order>
  <number type='integer'>488</number>
  <name>#1488</name>
  <created-at type='datetime'>2011-10-20T19:30:19-04:00</created-at>
  <total-discounts type='decimal'>0.0</total-discounts>
  <cancel-reason nil='true'/>
  <token>92d93330cba4ecfe41b4232ea6db46a0</token>
  <updated-at type='datetime'>2011-10-20T19:30:37-04:00</updated-at>
  <total-price type='decimal'>16.0</total-price>
  <landing-site>/collections/frontpage/products/extra-accountability-4-weekly-checkins-with-a-mentor?ref=t-coach_u-64185_g-105411_c-62733</landing-site>
  <taxes-included type='boolean'>false</taxes-included>
  <cancelled-at type='datetime' nil='true'/>
  <id type='integer'>83944852</id>
  <referring-site/>
  <total-line-items-price type='decimal'>16.0</total-line-items-price>
  <subtotal-price type='decimal'>16.0</subtotal-price>
  <note nil='true'/>
  <gateway>paypal</gateway>
  <fulfillment-status nil='true'/>  <financial-status>paid</financial-status>
  <currency>USD</currency>  <closed-at type='datetime' nil='true'/>
  <buyer-accepts-marketing type='boolean'>false</buyer-accepts-marketing>
  <total-tax type='decimal'>0.0</total-tax>
  <total-weight type='integer'>0</total-weight>
  <email>crysiss@gmail.com</email>
  <browser-ip>46.35.169.63</browser-ip>
  <landing-site-ref>t-coach_u-38789_g-103578_c-58884</landing-site-ref>
  <order-number type='integer'>1438</order-number>
  <tax-lines type='array'/>
  <shipping-address>
    <company nil='true'/>    <city>Rousse</city>
    <address1>73 Maliovitsa str</address1>
    <latitude type='decimal'>45.293901</latitude>
    <zip>7016</zip>
    <address2 nil='true'/>
    <country>Bulgaria</country>
    <phone nil='true'/>
    <last-name>Dimtirov</last-name>
    <longitude type='decimal'>-75.870465</longitude>
    <province>Ontario</province>
    <first-name>Rumen</first-name>
    <name>Rumen Dimtirov</name>
    <country-code>BG</country-code>
    <province-code>ON</province-code>
  </shipping-address>
  <shipping-lines type='array'/>
  <line-items type='array'>
    <line-item>
      <price type='decimal'>16.0</price>
      <product-id type='integer'>43003332</product-id>
      <title>In Your Corner: Get 4 Weekly Checkins with a HabitForge Mentor</title>
      <quantity type='integer'>1</quantity>
      <requires-shipping type='boolean'>false</requires-shipping>
      <id type='integer'>138510592</id>
      <grams type='integer'>0</grams>
      <sku/>
      <fulfillment-status nil='true'/>
      <variant-title nil='true'/>
      <vendor>HabitForge</vendor>
      <fulfillment-service>manual</fulfillment-service>      <variant-id type='integer'>99667232</variant-id>
      <name>In Your Corner: Get 4 Weekly Checkins with a HabitForge Mentor</name>    </line-item>
  </line-items>
  <customer>
    <accepts-marketing type='boolean'>false</accepts-marketing>
    <orders-count type='integer'>2</orders-count>
    <id type='integer'>38015382</id>
    <note nil='true'/>    <last-name>Dimtirov</last-name>
    <total-spent type='decimal'>20.99</total-spent>
    <first-name>Rumen</first-name>
    <email>crysiss@gmail.com</email>
    <tags/>
  </customer>
  <billing-address>
    <company nil='true'/>
    <city>Ottawa</city>
    <address1>8 Palomino Drive</address1>
    <latitude type='decimal'>45.293901</latitude>
    <zip>K2M 1L8</zip>
    <address2 nil='true'/>
    <country>Canada</country>
    <phone nil='true'/>
    <last-name>Dzuba</last-name>
    <longitude type='decimal'>-75.870465</longitude>
    <province>Ontario</province>
    <first-name>Rumen</first-name>
    <name>Rumen Dimtirov</name>
    <country-code>CA</country-code>
    <province-code>ON</province-code>
  </billing-address>
  <note-attributes type='array'>
  </note-attributes>
</order>    
}
        ### TESTING
        #doc = REXML::Document.new(testing_xml_user_upgrade_diff_email)
        #doc = REXML::Document.new(testing_xml_cause_diff_email_ref_came_through_false)
        #doc = REXML::Document.new(testing_xml_resend_any)
        
        ### PRODUCTION
        doc = REXML::Document.new request.body()


        logger.info 'xml SGJ done parsing xml'

      rescue
        #Return 400 Bad Request
        status = 400
      else
        logger.info 'Received an HF Shopify XML order file.'

        logger.info doc.to_s

        ###########################################################
        ###########################################################
        #### FIND THE USER
        ###########################################################
        account_located = 0

        xml_email = doc.elements["order/email"].text
        #xml_order_number = doc.elements["order/order_number"].text
        
        xml_browser_ip = "0.0.0.0"
        if doc.elements["order/browser-ip"] != nil
            xml_browser_ip = doc.elements["order/browser-ip"].text
        end

        ref_test = ""
        xml_user_id = 0
        xml_goal_id = 0
        xml_coach_id = 0
        xml_first_name = 'unknown'

        if doc.elements["order/billing-address/first-name"] != nil
          xml_first_name = doc.elements["order/billing-address/first-name"].text
        end
        
        ### Note that sometimes the landing-site-ref info doesn't come through
        ### So we have to do some digging to figure out who this is for
        ### and what goal it's for if a wager
        if doc.elements["order/landing-site-ref"] != nil
            ref_test = doc.elements["order/landing-site-ref"].text
            if ref_test == nil
                logger.info 'XML DOH!!! landing-site-ref is EMPTY!!!'
            else
                if ref_test.include? "t-cause"
                    logger.info 'XML looks like this will be a CAUSE order w/ ref of ' + ref_test
                    ### someone is signing up for a cause
                    ### their params will look like this: t-cause_u-44_g-23620
                    ### split those into an array to get the uid and gid
                    arr_ref = ref_test.split('_')
                    if arr_ref[1] != nil
                        if arr_ref[1].include? "u"
                            arr_ref_u = arr_ref[1].split('-')
                            if arr_ref_u[1] != nil
                                xml_user_id = arr_ref_u[1].to_i
                            end
                        end
                    end
                    if arr_ref[2] != nil
                        if arr_ref[2].include? "g"
                            arr_ref_g = arr_ref[2].split('-')
                            if arr_ref_g[1] != nil
                                xml_goal_id = arr_ref_g[1].to_i
                            end
                        end
                    end
                else
                    if ref_test.include? "t-coach"
                        logger.info 'XML looks like this will be a COACH order w/ ref of ' + ref_test
                        ### someone is signing up for extra accountability aka coaching
                        ### their params will look like this: t-coach_u-44_g-23620_c-56834
                        ### split those into an array to get the uid and gid
                        arr_ref = ref_test.split('_')
                        if arr_ref[1] != nil
                            if arr_ref[1].include? "u"
                                arr_ref_u = arr_ref[1].split('-')
                                if arr_ref_u[1] != nil
                                    xml_user_id = arr_ref_u[1].to_i
                                end
                            end
                        end
                        if arr_ref[2] != nil
                            if arr_ref[2].include? "g"
                                arr_ref_g = arr_ref[2].split('-')
                                if arr_ref_g[1] != nil
                                    xml_goal_id = arr_ref_g[1].to_i
                                end
                            end
                        end
                        logger.info 'XML about to grab value for param c'
                        if arr_ref[3] != nil
                            logger.info 'XML item 3 is not nil'
                            if arr_ref[3].include? "c"
                                logger.info 'XML item 3 contains c'
                                arr_ref_c = arr_ref[3].split('-')
                                if arr_ref_c[1] != nil
                                    logger.info 'XML arr_ref_c[1] is not nil'
                                    xml_coach_id = arr_ref_c[1].to_i
                                    logger.info 'XML arr_ref_c[1] is ' + xml_coach_id.to_s
                                end
                            end
                        end
                    else
                        logger.info 'XML looks like this will be an UPGRADE order w/ ref of ' + ref_test
                        ### this is a standard account upgrade
                        xml_user_id = ref_test.to_i
                    end
                end
            end            
        end

        xml_payments = 0.0
        if doc.elements["order/total-price"] != nil
            xml_payments = doc.elements["order/total-price"].text
        end

        logger.info 'XML searching for email of:' + xml_email
        
        user = User.find(:first, :conditions => "email = '#{xml_email}'") 
        if user != nil
            logger.info 'XML SUCCESS order from found user ' + user.email
            account_located = 1
        else

            logger.info 'XML WARN order from unknown user ' + xml_email + '...will search for user.id of ' + xml_user_id.to_s
            user = User.find(:first, :conditions => "id = #{xml_user_id}") 
            if user != nil
                logger.info 'XML SUCCESS order received from found user (located by user.id) ' + user.email
                account_located = 1
            else
                logger.info 'XML WARN order from unknown user ' + xml_email + '...will search for browser_ip of ' + xml_browser_ip
                user = User.find(:first, :conditions => "current_login_ip = '#{xml_browser_ip}'") 
                if user != nil
                    logger.info 'XML SUCCESS order received from found user (located by IP) ' + user.email
                    account_located = 1
                else

                  ### WE COULD NOT FIND A USER W/ THAT EMAIL OR THAT ID OR THAT BROWSER IP
                  ### SO LET's CREATE THAT USER NOW
                  user = User.new
                  user.first_name = xml_first_name
                  user.last_name = ""
                  user.email = xml_email
                  user.email_confirmation = xml_email
                  random_pw_number = rand(1000) + 1 #between 1 and 1000
                  user.password = "xty" + random_pw_number.to_s
                  user.password_confirmation = user.password
                  user.password_temp = user.password
                  user.sponsor = "habitforge"
                  user.time_zone = "Central Time (US & Canada)"
                  ### having periods in the first name kills the attempts to email that person, so remove periods
                  user.first_name = user.first_name.gsub(".", "")
                  ### Setting this to something other than 0 so that this person
                  ### is included in the next morning's cron job to send emails
                  ### this will get reset to the right number once each day via cron
                  ### but set it now in case user is being created after that job runs
                  user.update_number_active_goals = 1
                  ### update last activity date
                  user.last_activity_date = user.dtoday

                  if user.save
                    account_located = 1
                    logger.info "XML Created User who did not exist: " + xml_email


                    begin
                      #### ALLOW FOR EMAIL ADDRESS CONFIRMATION
                      random_confirm_token = rand(1000) + 1 #between 1 and 1000
                      user.confirmed_address_token = "xtynzsc" + random_confirm_token.to_s
                      user.save

                      #### now that we have saved and have the user id, we can send the email 
                      the_subject = "Confirm your HabitForge Subscription"
                      Notifier.deliver_user_confirm(user, the_subject) # sends the email
                    rescue
                      logger.error("sgj:email confirmation for user creation did not send")
                    end

                  else
                    logger.info "XML failed to create User who did not exist: " + xml_email
                  end

                end
            end





            # logger.info 'XML WARN order from unknown user ' + xml_email + '...will search for user.id of ' + xml_user_id.to_s
            # user = User.find(:first, :conditions => "id = #{xml_user_id}") 
            # if user != nil
            #     logger.info 'XML SUCCESS order received from found user (located by user.id) ' + user.email
            #     account_located = 1
            # else
            #     logger.info 'XML WARN order from unknown user ' + xml_email + '...will search for browser_ip of ' + xml_browser_ip
            #     user = User.find(:first, :conditions => "current_login_ip = '#{xml_browser_ip}'") 
            #     if user != nil
            #         logger.info 'XML SUCCESS order received from found user (located by IP) ' + user.email
            #         account_located = 1
            #     else

            #         logger.info 'XML NOTICE order from unknown user ' + xml_email + ' and unknown user_id ' + xml_user_id.to_s + ' and unknown browser_ip ' + xml_browser_ip
            #     end
            # end



        end
        ###########################################################
        #### END FIND THE USER
        ###########################################################
        ###########################################################



###### BROKEN TESTING
###Processing HooksController#create (for 67.192.100.64 at 2011-04-30 07:20:13) [POST]
###2011-04-30 12:20:13 GMT | INFO | 38079 |   Parameters: {"action"=>"create", "controller"=>"hooks"}
###2011-04-30 12:20:13 GMT | INFO | 38079 | Received an HF Shopify XML order file.
###2011-04-30 12:20:13 GMT | INFO | 38079 | XML searching for email of:jon@doe.ca
###2011-04-30 12:20:13 GMT | INFO | 38079 | XML SUCCESS order from found user jon@doe.ca
###2011-04-30 12:20:13 GMT | INFO | 38079 | XML About to Iterate through Line Items
###2011-04-30 12:20:13 GMT | INFO | 38079 | XML HEY WE SHOULD ACTUALLY Tell shopify that the order is fulfilled
###2011-04-30 12:20:13 GMT | INFO | 38079 | Completed in 33ms (View: 0, DB: 1) | 200 OK [http://habitforge.com/hooks/order/create]
###2011-04-30 12:20:16 GMT | INFO | 38079 | 

#### ITERATION EXAMPLE
#### as per http://www.java2s.com/Code/Ruby/XML/ExtractingDataFromaDocumentsTreeStructure.htm
####   orders_xml = %{
####   <orders>
####     <order>
####       <number>1</number>
####       <date>02/10/2008</date>
####       <customer>C</customer>
####       <items>
####         <item upc="0" desc="Roses" qty="240" />
####         <item upc="1" desc="Candy" qty="160" />
####       </items>
####     </order>
####   </orders>}
####   
####   require 'rexml/document'
####   orders = REXML::Document.new(orders_xml)
####   orders.root.each_element do |order|     # each <order> in <orders>
####     order.each_element do |node|          # <customer>, <items>, etc. in <order>
####       if node.has_elements?
####         node.each_element do |child|      # each <item> in <items>
####           puts "#{child.name}: #{child.attributes['desc']}"
####         end
####       else
####         # the contents of <number>, <date>, etc.
####         puts "#{node.name}: #{node.text}"
####       end
####     end
####   end


        xml_product_id = 0
	xml_variant_id = 0
        ### Iterate through each line item and check each product id
        ### to determine whether the user is upgrading their account
        ### or if they're buying cause credits for a goal
        logger.info 'XML About to Iterate through Line Items'


        #doc.elements["order/line-items"].each_child do |line-item|

        
        #doc.elements.each_child{ |child| # Do something with child }
        
        line_item_counter = 0
        doc.elements.each('order/line-items') do |item|        
           line_item_counter = line_item_counter + 1
        
           logger.info 'XML Looking at Line Item #' + line_item_counter.to_s
           
	   ### get the price, and add another 0 if the decimal value was something like 10.0
	   xml_price = item.elements['line-item/price'].text.to_s
	   if xml_price.split(//).last(2).to_s == ".0"
	     xml_price = xml_price + "0"
           end

           xml_product_id = item.elements['line-item/product-id'].text.to_i
	   xml_variant_id = item.elements['line-item/variant-id'].text.to_i
	
           if xml_product_id == 49 or xml_product_id == 33131182 or xml_product_id == 63752422 or xml_product_id == 63868112 or xml_product_id == 63752802 or xml_product_id == 63753272 or xml_product_id == 43003332

           #if (xml_product_id == 49 and xml_variant_id == 27) or xml_product_id == 33131182 or xml_product_id == 63752422 or xml_product_id == 63868112 or xml_product_id == 63752802 or xml_product_id == 63753272 or xml_product_id == 43003332



	     #### INFUSION SOFT PRODUCT IDS
 	     #### product-id = 49 and variant-id = 27 := 12-month @ $9.95
             #### product-id = 49 and variant-id = 31 := 12-month @ $9.95 (w/ some discount code, perhaps any code)

             #### NEW VARIANT-IDs !!! 20130114
             #### 27 => current $9.95/year
             #### 29 => new $3.95/month
             #### 31 => new $29/year
             #### 99 = > new $99 Lifetime
             #### OLD: 0 = > new $99 Lifetime



	     #### SHOPIFY PRODUCT IDs
             ### 33131182 = 12-month Supporting Membership
             ### 43003332 = Extra Accountability (aka "coach")

             ### 63868112 = 3-month Supporting Membership
             ### 63752422 = 6-month Supporting Membership
             ### 63752802 = 2-year Supporting Membership
             ### 63753272 = 5 year Supporting Membership
             ############################################
             #### START ACCOUNT UPGRADE ONLY PORTION
             if xml_product_id == 49 or xml_product_id == 33131182 or xml_product_id == 63752422 or xml_product_id == 63868112 or xml_product_id == 63752802 or xml_product_id == 63753272
                 logger.info 'XML This Line Item is for an Account Upgrade'
                 ### If their email exists in our db, upgrade their account
                 account_upgraded = 0
             
                 if account_located == 0
                     ### Send email to user and CC support asking what email address they use for HF
                     logger.info 'XML ATTEMPTING TO SEND email to user and CC support asking what email address they use for HF'
                     Notifier.deliver_user_upgrade_unknown_notification(xml_email) # sends the email
                 end
             
                 if account_located == 1
             
                     ### GET DATE NOW ###
                     jump_forward_days = 0
                     if user
                       Time.zone = user.time_zone
                       tnow = Time.zone.now #User time
                     else
                       tnow = Time.now
                     end
                     tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
                     tnow_m = tnow.strftime("%m").to_i #month of the year
                     tnow_d = tnow.strftime("%d").to_i #day of the month
                     tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
                     tnow_M = tnow.strftime("%M").to_i #minute of the hour
                     #puts tnow_Y + tnow_m + tnow_d  
                     #puts "Current timestamp is #{tnow.to_s}"
                     dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
                     ######
             
             
                     ### Upgrade their account
                     logger.info 'XML Attempting to upgrade their account'
                     user.combine_daily_emails = 0
                     user.hide_donation_plea = 1
                     user.unlimited_goals = 1


                     ### HOW LONG DID THEY PAY FOR???
                     ### Default is 1 year
                     days_to_add = 365

                     ### 63868112 = 3-month Supporting Membership
                     if xml_product_id == 63868112
                         days_to_add = 92
                     end
                     
                     ### 63752422 = 6-month Supporting Membership
                     if xml_product_id == 63752422
                         days_to_add = 183
                     end

                     ### 33131182 = 12-month Supporting Membership
                     if xml_product_id == 33131182
                         days_to_add = 365
                     end

                     ### 63752802 = 2-year Supporting Membership
                     if xml_product_id == 63752802
                         days_to_add = 730
                     end

                     ### 63753272 = 5-year Supporting Membership
                     if xml_product_id == 63753272
                         days_to_add = 1825
                     end

                     ### If their account is expired, add from today
                     ### otherwise, add from their future expiration date
                     if user.kill_ads_until == nil
                         user.kill_ads_until = dnow + days_to_add
                     else
                         if dnow >= user.kill_ads_until
                             user.kill_ads_until = dnow + days_to_add
                         else
                             user.kill_ads_until = user.kill_ads_until + days_to_add
                         end
                     end
                     user.sent_expire_warning_on = '1900-01-01'

		                 if xml_product_id == 49
                			user.kill_ads_until = '3000-01-01'
                      if xml_variant_id == 27 or xml_variant_id == 31 or xml_variant_id == 32
                			  user.plan = "Yearly"
                			end
                      if xml_variant_id == 29
                			  user.plan = "Monthly"
                			end
                      if xml_variant_id == 99 or xml_variant_id == 0
                			  user.plan = "Lifetime"
                			end
                			user.plan = user.plan + " @ $" + xml_price
                     end
             
                     if user.payments == nil
                         user.payments = 0.0
                     end
                     ### Look for Issues here with the BigInteger type via xml
                     user.payments = user.payments + xml_payments.to_i
             
                     user.last_donation_date = dnow
             
                     if user.save
                         logger.info 'XML SUCCESS upgrading user account for ' + user.email
                     else 
                         logger.info 'XML ERROR upgrading user account for ' + user.email
                     end
                     ### Send email to user and CC support w/ thank you and upgrade info
                     logger.info 'XML ATTEMPTING TO Send email to user and CC support w/ thank you and upgrade info'

                     ### 63868112 = 3-month Supporting Membership
                     if xml_product_id == 63868112
                         Notifier.deliver_user_upgrade_3month_notification(user) # sends the email
                     end
                     ### 63752422 = 6-month Supporting Membership
                     if xml_product_id == 63752422
                         Notifier.deliver_user_upgrade_6month_notification(user) # sends the email
                     end
                     ### 63752802 = 2-year Supporting Membership
                     if xml_product_id == 63752802
                         Notifier.deliver_user_upgrade_2year_notification(user) # sends the email
                     end
                     ### 63753272 = 5-year Supporting Membership
                     if xml_product_id == 63753272
                         Notifier.deliver_user_upgrade_5year_notification(user) # sends the email
                     end

                     ### 33131182
		     ### 12-month Supporting Membership
                     if (xml_product_id == 49 and xml_variant_id > 0) or xml_product_id == 33131182
                         Notifier.deliver_user_upgrade_notification(user) # sends the email
                     end


                 end

             end
             #### END ACCOUNT UPGRADE ONLY PORTION
             ############################################

             ############################################                 
             #### START EXTRA ACCOUNTABILITY (COACHING) ONLY PORTION
             if xml_product_id == 43003332
                 logger.info 'XML This Line Item is for Extra Accountability (aka coaching)'

                 ### If their email exists in our db, upgrade or extend their account
                 account_upgraded = 0
             
                 if account_located == 0
                     ### Send email to user and CC support asking what email address they use for HF
                     logger.info 'XML ATTEMPTING TO SEND email to user and CC support asking what email address they use for HF'
                     Notifier.deliver_user_extraacc_unknown_notification(xml_email) # sends the email
                 end
             
                 if account_located == 1
             
                     ### GET DATE NOW ###
                     jump_forward_days = 0
                     if user
                       Time.zone = user.time_zone
                       tnow = Time.zone.now #User time
                     else
                       tnow = Time.now
                     end
                     tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
                     tnow_m = tnow.strftime("%m").to_i #month of the year
                     tnow_d = tnow.strftime("%d").to_i #day of the month
                     tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
                     tnow_M = tnow.strftime("%M").to_i #minute of the hour
                     #puts tnow_Y + tnow_m + tnow_d  
                     #puts "Current timestamp is #{tnow.to_s}"
                     dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
                     ######
             
             
                     ### Upgrade their account
                     logger.info 'XML Attempting to upgrade their account'
                     user.combine_daily_emails = 0
                     user.hide_donation_plea = 1
                     user.unlimited_goals = 1
                     days_to_add = 365

                     ### If their account is expired, add from today
                     ### otherwise, add from their future expiration date
                     if user.kill_ads_until == nil
                         user.kill_ads_until = dnow + days_to_add
                     else
                         if dnow >= user.kill_ads_until
                             user.kill_ads_until = dnow + days_to_add
                         else
                             user.kill_ads_until = user.kill_ads_until + days_to_add
                         end
                     end
                     user.sent_expire_warning_on = '1900-01-01'
                     

                     if xml_goal_id == 0
                         ### We weren't able to determine the goal ID for this user based
                         ### on the params ... let's try to figure it out though
                         logger.info "XML We weren't able to determine the goal ID for this user based"
                         logger.info "XML on the params ... trying to determine what goal it's for"
                 
                         if account_located == 1
                            if user != nil
                               @goals = Goal.find(:all, :conditions => "user_id = '#{user.id}' and (status = 'start' or status = 'monitor')") 
                               if @goals.size == 1
                                   for goal in @goals
                                       xml_goal_id = goal.id
                                   end
                               end
                            end
                         end
                     end

                     if xml_goal_id == 0
                         ### We still weren't able to determine the goal ID for this user based
                         ### will need to manually investigate which goal it is for
                         logger.info "XML Still not able to determine the goal ID for this user"
                         logger.info "XML will need to manually investigate which goal it is for"

                         if account_located == 1 and user != nil
                             logger.info 'XML We know what HF user this is, but we can not determine what goal to put this coaching on'
                             logger.info 'XML Send email to user and CC support asking what goal to put it on'
                             Notifier.deliver_coach_goal_unknown_notification(user.email) # sends the email
                         else
                             ### Send email to user and CC support asking what email address they use for HF
                             logger.info 'XML ATTEMPTING TO SEND email to user and CC support asking what email address they use for HF'
                             Notifier.deliver_coach_user_unknown_notification(xml_email) # sends the email
                         end


                     else
                         ### We have the GOAL ID from the params
                         logger.info "XML We know that this COACHING is for goal #" + xml_goal_id.to_s

                         goal = Goal.find(:first, :conditions => "id = '#{xml_goal_id}'")
                         if goal   
                             logger.info("XML: found goal for COACHING")

                            ### PSEUDOCODE
                            ### when someone signs up for coaching w/ a coach
                            ###   add is_coached to goal
                            ###   add coachgoal_id to goal
                            ###   create coachgoal record
                            ###     coach_id
                            ###     goal_id 
                            ###     goal_name (in case goal is deleted)
                            ###     user_id
                            ###     user_email (in case user is deleted
                            ###     user_first_name (in case user is deleted
                            ###     amount_client_paid_total
                            ###     amount_client_paid_split_to_site
                            ###     amount_client_paid_split_to_coach
                            ###     week_1_email_due_date
                            ###     week_2_email_due_date
                            ###     week_3_email_due_date
                            ###     week_4_email_due_date
                            ###     is_active (only re-set to "no" via cron)
                            ###
                            ###   an email is sent to client with details
                            ###   an email is sent to coach with details
                            ###   a "cheers/follow" record is created between the client and coach
                            ###   increment coachuser.client_count_active
                            ###   increment coachuser.client_count_cumulative
                            
                            
                            if xml_coach_id == 0
                                ### The coach id didn't come through ... choose one
                                logger.info 'XML coach id did not come through, so choose one'
                                
                                ### see if any coaches are available, period
                                available_coaches = Coach.find(:all, :conditions => "is_willing_to_work = 1 and (client_count_active < client_count_limit )")
                                if available_coaches != nil and available_coaches.size > 0
                                    logger.info 'XML COACHING:found available coach(es).'

                                    ### see if any available coaches specialize in this goal's category
                                    arr_for_hire = Array.new
                                    for coach in available_coaches
                                        if coach.categories.include? goal.category
                                            ### found one, add it to array of "for hire" coaches
                                            arr_for_hire.push([coach.id])
                                        end
                                    end
                                    if arr_for_hire.size > 0
                                        logger.info 'XML COACHING:found coach(es) for this category.'
            
                                        chosen_coach_id = 0
                                        chosen_coach = Coach.new
            
                                        ### We have at least one coach for hire
                                        if arr_for_hire.size == 1
                                            logger.info 'XML COACHING:found just one coach for this category.'

                                            ### We just have one to choose
                                            chosen_coach_id = arr_for_hire[0]
                                        else
                                            logger.info 'XML COACHING:found multiple coaches for this category.'

                                            ### We have more than one, let's randomly choose one!
                                            random_user_number = 0
                                            random_user_number = rand(arr_for_hire.size) + 0 #between 0 and arr_for_hire.size
                                            chosen_coach_id = arr_for_hire[random_user_number]
                                        end
            
                                        chosen_coach = Coach.find(:first, :conditions => "id = #{chosen_coach_id}")
                                        if chosen_coach != nil
                                            logger.info 'XML COACHING:we chose a coach.'
                                            xml_coach_id = chosen_coach.id
                                        end ### end Found Chosen Coach
                                    end ### end Whether we have coaches available for this category
                                end ### end Whether we have coaches available at the moment, for any category                                
                            end

                            ### Sometimes these get stuck, so
                            ### don't allow for creation of duplicates
                            coachgoal = Coachgoal.find(:first, :conditions => "goal_id = #{goal.id} and is_active = 1")
                            if coachgoal == nil
                                ### Cool, we don't have a record yet, so continue

                                ### Create a new coachgoal
                                coachgoal = Coachgoal.new()


                                coach = Coach.find(:first, :conditions => "user_id = #{xml_coach_id}")
                                if coach != nil
                                    logger.info 'XML COACHING:we have our coach.'
                                    coachgoal.coach_id = coach.id

                                    if coach.client_count_cumulative == nil
                                        coach.client_count_cumulative = 1
                                    else
                                        coach.client_count_cumulative = coach.client_count_cumulative + 1
                                    end

                                    if coach.client_count_active == nil
                                        coach.client_count_active = 1
                                    else
                                        coach.client_count_active = coach.client_count_active + 1
                                    end

                                    coach.save
                                    logger.info 'XML COACHING: Coach record saved.'
                                
                                    cheer = Cheer.new()
                                    cheer.email = coach.user.email
                                    cheer.goal_id = goal.id
                                    cheer.save
                                    logger.info 'XML COACHING: Cheer record saved.'

                                else
                                    logger.info 'XML COACHING: WE DO NOT HAVE A COACH.'
                                    ### We don't seem to have an available coach 
                                    ### (it didn't come through, or is invalid, and/or none is available now)
                                    coachgoal.coach_id = 0
                                
                                end


                                coachgoal.goal_id = goal.id
                                coachgoal.goal_name = goal.title
                                coachgoal.user_id = user.id
                                coachgoal.user_email = user.email
                                coachgoal.user_first_name = user.first_name
                                coachgoal.amount_client_paid_total = 0.0 + xml_payments.to_i
                                coachgoal.amount_client_paid_split_to_site = coachgoal.amount_client_paid_total/2
                                coachgoal.amount_client_paid_split_to_coach = coachgoal.amount_client_paid_total/2
                                coachgoal.week_1_email_due_date = dnow + 7
                                coachgoal.week_2_email_due_date = dnow + 14
                                coachgoal.week_3_email_due_date = dnow + 21
                                coachgoal.week_4_email_due_date = dnow + 28
                                coachgoal.is_active = 1
                                coachgoal.save
                            
                                ### Update Goal Record
                                goal.is_coached = 1
                                goal.coachgoal_id = coachgoal.id
                                goal.save


                                 if user.payments == nil
                                     user.payments = 0.0
                                 end
                                 ### Look for Issues here with the BigInteger type via xml
                                 user.payments = user.payments + xml_payments.to_i
             
                                 user.last_donation_date = dnow
                                    
             
                                 if user.save
                                     logger.info 'XML SUCCESS upgrading user account for ' + user.email
                                 else 
                                     logger.info 'XML ERROR upgrading user account for ' + user.email
                                 end
                                 ### Send email to user and CC support w/ thank you and upgrade info
                                 logger.info 'XML ATTEMPTING TO Send email to user and CC support w/ Weekly Check-in and upgrade info'
                                 Notifier.deliver_user_extraacc_upgrade_notification(coachgoal) # sends the email             

                                 if coachgoal.coach_id == 0
                                     logger.info 'XML ATTEMPTING TO Send email to support re: no coach'
                                     Notifier.deliver_support_coachgoal_missing_coach_notification(coachgoal) # sends the email             
                                 else
                                     logger.info 'XML ATTEMPTING TO Send email to coach w/ instructions'
                                     Notifier.deliver_coach_coachgoal_notification(coachgoal) # sends the email             
                                 end

                                
                            end

                         else
                             logger.info "XML: no such GOAL in rails db w/ goal id of " + xml_goal_id.to_s

                             logger.info 'XML Send email to user and CC support asking what goal to put it on'
                             Notifier.deliver_coach_goal_unknown_notification(user.email) # sends the email
                         end
                     end


                 end
             end
             #### END EXTRA ACCOUNTABILITY (COACHING) ONLY PORTION
             ############################################                 
           end  
           #else
           ### commented out the below for now, since we're not doing cause credits anymore
           if 1 == 0 
             ### not 33131182 or 43003332, so User is likely cause credits for their goal
             
             #### REMEMBER, THERE ARE MANY CAUSE CREDIT ITEM-IDs,
             #### WHICH IS WHY THIS IS CURRENTLY A CATCH ALL
             logger.info 'XML This Line Item is NOT for an Account Upgrade (probably Cause Credits for a Goal)'

             if xml_goal_id == 0
                 ### We weren't able to determine the goal ID for this user based
                 ### on the params ... let's try to figure it out though
                 logger.info "XML We weren't able to determine the goal ID for this user based"
                 logger.info "XML on the params ... trying to determine what goal it's for"
                 
                 if account_located == 1
                    if user != nil
                       @start_goals = Goal.find(:all, :conditions => "user_id = '#{user.id}' and status = 'start' and established_on = '1900-01-01'") 
                       if @start_goals.size == 1
                           for goal in @start_goals
                               xml_goal_id = goal.id
                           end
                       end
                    end
                 end
             end

             if xml_goal_id == 0
                 ### We still weren't able to determine the goal ID for this user based
                 ### will need to manually investigate which goal it is for
                 logger.info "XML Still not able to determine the goal ID for this user"
                 logger.info "XML will need to manually investigate which goal it is for"

                 if account_located == 1 and user != nil
                     logger.info 'XML We know what HF user this is, but we can not determine what goal to put this wager on'
                     logger.info 'XML Send email to user and CC support asking what goal to put it on'
                     Notifier.deliver_bet_goal_unknown_notification(user.email) # sends the email
                 else
                     ### Send email to user and CC support asking what email address they use for HF
                     logger.info 'XML ATTEMPTING TO SEND email to user and CC support asking what email address they use for HF'
                     Notifier.deliver_bet_user_unknown_notification(xml_email) # sends the email
                 end


             else
                 ### We have the GOAL ID from the params
                 logger.info "XML We know that this CAUSE is for goal #" + xml_goal_id.to_s

                 goal = Goal.find(:first, :conditions => "id = '#{xml_goal_id}'")
                 if goal   
                     logger.info("XML: found goal for CAUSE")

                     betpayee = Betpayee.find(:first, :conditions => "product_id = '#{xml_product_id}'")
                     if betpayee   

                        ### GET DATE NOW ###
                        jump_forward_days = 0
                        if user
                          Time.zone = user.time_zone
                          tnow = Time.zone.now #User time
                        else
                          tnow = Time.now
                        end
                        tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
                        tnow_m = tnow.strftime("%m").to_i #month of the year
                        tnow_d = tnow.strftime("%d").to_i #day of the month
                        tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
                        tnow_M = tnow.strftime("%M").to_i #minute of the hour
                        #puts tnow_Y + tnow_m + tnow_d  
                        #puts "Current timestamp is #{tnow.to_s}"
                        dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
                        tomorrow = dnow + 1
                        ######


                        ### Determine amount "wagered"
                        ###       <price type='decimal'>9.99</price>
                        ###       <product-id type='integer'>33131182</product-id>
                        ###       <title>12 Month Supporting Membership</title>
                        ###       <quantity type='integer'>1</quantity>

                        xml_price = item.elements['line-item/price'].text.to_f
                        xml_quantity = item.elements['line-item/quantity'].text.to_i
                        wager = xml_price * xml_quantity
                        
                        ### Create a new bet
                        new_bet = Bet.new()
                        new_bet.betpayee = betpayee
                        new_bet.goal = goal
                        new_bet.wager = wager
                        new_bet.start_date = tomorrow
                        new_bet.end_date = tomorrow + 30
                        new_bet.success_rate = 100
                        new_bet.active_yn = 1
                        new_bet.save  
                         
                        logger.info 'XML ATTEMPTING TO SEND CAUSE ADDED email to user and CC support giving details and thanks '
                        Notifier.deliver_bet_added_notification(user) # sends the email


                         
                     else
                         logger.info "XML: no such CAUSE in rails db w/ product id of " + xml_product_id.to_s

                         logger.info 'XML Send email to user and CC support asking what goal to put it on'
                         Notifier.deliver_bet_goal_unknown_notification(user.email) # sends the email
                     end
                 else
                     logger.info "XML: no such GOAL in rails db w/ goal id of " + xml_goal_id.to_s

                     logger.info 'XML Send email to user and CC support asking what goal to put it on'
                     Notifier.deliver_bet_goal_unknown_notification(user.email) # sends the email
                 end
             end
           end
        end

        ### Tell shopify that the order is fulfilled
        logger.info 'XML HEY WE SHOULD ACTUALLY Tell shopify that the order is fulfilled'
        #As per: http://api.shopify.com/fulfillment.xml.html
        #Fulfill all line items for an order and send the shipping confirmation email. Not specifying line item IDs causes all line items for the order to be fulfilled.
        #
        #POST /admin/orders/#{id}/fulfillments.xml
        #
        #<?xml version="1.0" encoding="UTF-8"?>
        #<fulfillment>
        #  <notify-customer type="boolean">true</notify-customer>
        #  <tracking-number>123456789</tracking-number>
        #</fulfillment>   

        #url = URI.parse('http://localhost:3000/someservice/')
        #request = Net::HTTP::Post.new(url.path)
        #request.body = "<?xml version='1.0' encoding='UTF-8'?><somedata><name>Test Name 1</name><description>Some data for Unit testing</description></somedata>"
        #response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}

        #url = URI.parse('https://habitforge.myshopify.com/admin/orders/' + xml_order_number + '/fulfillments.xml')
        #request = Net::HTTP::Post.new(url.path)
        #request.body = "<?xml version='1.0' encoding='UTF-8'?><fulfillment><notify-customer type='boolean'>false</notify-customer><tracking-number>#{user.id.to_s}</tracking-number></fulfillment>"
        #response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}


        ### Shopify will keep sending the XML file until you tell them OK        
        #Return 200 OK
        status = 200
      end
      
      ###COMMENT OUT THE NEXT LINE WHEN TESTING LOCALLY
      ###UNCOMMENT THE NEXT LINE IN PRODUCTION
    end

    render :nothing => true, :status => status
  end
end


######################################################################################################
############ LIVE XML DUMP for live EXTRA ACCOUNTABILITY PURCHASE of $29 Prior to hooks being able to react fully
######################################################################################################
###
###Processing HooksController#create (for 204.93.213.120 at 2011-06-08 04:48:41) [POST]2011-06-08 09:48:41 GMT | INFO | 46870 |   Parameters: {"action"=>"create", "order"=>{"name"=>"#1309", "number"=>309, "tax_lines"=>[], "line_items"=>[{"price"=>#<BigDecimal:2b87db3b9190,'0.29E2',9(18)>, "name"=>"Extra Accountability: 4 Weekly Checkins with the HabitForge Creator", "product_id"=>43003332, "requires_shipping"=>false, "title"=>"Extra Accountability: 4 Weekly Checkins with the HabitForge Creator", "quantity"=>1, "id"=>111287682, "grams"=>0, "sku"=>nil, "vendor"=>"HabitForge", "variant_title"=>nil, "fulfillment_status"=>nil, "fulfillment_service"=>"manual", "variant_id"=>99667232}], "total_discounts"=>#<BigDecimal:2b87db3bb170,'0.0',9(18)>, "created_at"=>Wed Jun 08 09:48:30 UTC 2011, "browser_ip"=>"86.81.178.232", "cancel_reason"=>nil, "total_price"=>#<BigDecimal:2b87db3af000,'0.29E2',9(18)>, "token"=>"b028f32c8f3254c2636c046c68652f3c", "landing_site_ref"=>"59105", "updated_at"=>Wed Jun 08 09:48:40 UTC 2011, "landing_site"=>"/collections/frontpage/products/extra-accountability-4-weekly-checkins-with-the-habitforge-creator?ref=59105", "taxes_included"=>false, "shipping_lines"=>[], "shipping_address"=>{"name"=>"Jolanda Pikkaart", "address1"=>"B. Zweerslaan 15", "city"=>"Baarn", "company"=>nil, "address2"=>nil, "zip"=>"3741 HL", "latitude"=>#<BigDecimal:2b87db3aa3e8,'0.52219496E2',18(18)>, "country"=>"Netherlands", "country_code"=>"NL", "province_code"=>nil, "last_name"=>"Pikkaart", "phon
###e"=>nil, "longitude"=>#<BigDecimal:2b87db3a66f8,'0.5268609E1',18(18)>, "province"=>nil, "first_name"=>"Jolanda"}, "id"=>67111902, "cancelled_a
###t"=>nil, "order_number"=>1309, "total_line_items_price"=>#<BigDecimal:2b87db3a3cf0,'0.29E2',9(18)>, "referring_site"=>"http://habitforge.com/g
###oals", "subtotal_price"=>#<BigDecimal:2b87db396dc0,'0.29E2',9(18)>, "billing_address"=>{"name"=>"Jolanda Pikkaart", "address1"=>"B. Zweerslaan
### 15", "city"=>"Baarn", "company"=>nil, "address2"=>nil, "zip"=>"3741 HL", "latitude"=>#<BigDecimal:2b87db39e890,'0.52219496E2',18(18)>, "count
###ry"=>"Netherlands", "country_code"=>"NL", "province_code"=>nil, "last_name"=>"Pikkaart", "phone"=>nil, "longitude"=>#<BigDecimal:2b87db398e18,
###'0.5268609E1',18(18)>, "province"=>nil, "first_name"=>"Jolanda"}, "note"=>nil, "note_attributes"=>[], "closed_at"=>nil, "buyer_accepts_marketi
###ng"=>false, "financial_status"=>"paid", "fulfillment_status"=>nil, "customer"=>{"accepts_marketing"=>false, "orders_count"=>1, "tags"=>nil, "i
###d"=>45961222, "last_name"=>"Pikkaart", "note"=>nil, "total_spent"=>#<BigDecimal:2b87db38ab38,'0.29E2',9(18)>, "first_name"=>"Jolanda", "email"
###=>"woody12@planet.nl"}, "currency"=>"USD", "gateway"=>"paypal", "total_tax"=>#<BigDecimal:2b87db387bb8,'0.0',9(18)>, "total_weight"=>0, "email
###"=>"woody12@planet.nl"}, "controller"=>"hooks"}
###2011-06-08 09:48:41 GMT | INFO | 46870 | Received an HF Shopify XML order file.
###2011-06-08 09:48:41 GMT | INFO | 46870 | <?xml version='1.0' encoding='UTF-8'?>
###<order>
###  <number type='integer'>309</number>
###  <name>#1309</name>
###  <created-at type='datetime'>2011-06-08T05:48:30-04:00</created-at>
###  <total-discounts type='decimal'>0.0</total-discounts>
###  <cancel-reason nil='true'/>
###  <token>b028f32c8f3254c2636c046c68652f3c</token>
###  <updated-at type='datetime'>2011-06-08T05:48:40-04:00</updated-at>
###  <total-price type='decimal'>29.0</total-price>
###  <landing-site>/collections/frontpage/products/extra-accountability-4-weekly-checkins-with-the-habitforge-creator?ref=59105</landing-site>
###  <taxes-included type='boolean'>false</taxes-included>
###  <cancelled-at type='datetime' nil='true'/>
###  <id type='integer'>67111902</id>
###  <referring-site>http://habitforge.com/goals</referring-site>
###  <total-line-items-price type='decimal'>29.0</total-line-items-price>
###  <subtotal-price type='decimal'>29.0</subtotal-price>
###  <note nil='true'/>
###  <gateway>paypal</gateway>
###  <fulfillment-status nil='true'/>
###  <financial-status>paid</financial-status>
###  <currency>USD</currency>
###  <closed-at type='datetime' nil='true'/>
###  <buyer-accepts-marketing type='boolean'>false</buyer-accepts-marketing>
###  <total-tax type='decimal'>0.0</total-tax>
###  <total-weight type='integer'>0</total-weight>
###  <email>woody12@planet.nl</email>
###  <browser-ip>86.81.178.232</browser-ip>
###  <landing-site-ref>59105</landing-site-ref>
###  <order-number type='integer'>1309</order-number>
###  <customer>
###    <accepts-marketing type='boolean'>false</accepts-marketing>
###    <orders-count type='integer'>1</orders-count>
###    <id type='integer'>45961222</id>
###    <note nil='true'/>
###    <last-name>Pikkaart</last-name>
###    <total-spent type='decimal'>29.0</total-spent>
###    <first-name>Jolanda</first-name>
###    <email>woody12@planet.nl</email>
###    <tags/>
###  </customer>
###  <billing-address>
###    <company nil='true'/>
###    <city>Baarn</city>
###    <address1>B. Zweerslaan 15</address1>
###    <latitude type='decimal'>52.219496</latitude>
###    <zip>3741 HL</zip>
###    <address2 nil='true'/>
###    <country>Netherlands</country>
###    <phone nil='true'/>
###    <last-name>Pikkaart</last-name>
###    <longitude type='decimal'>5.268609</longitude>
###    <province nil='true'/>
###    <first-name>Jolanda</first-name>
###    <name>Jolanda Pikkaart</name>
###    <country-code>NL</country-code>
###    <province-code nil='true'/>
###  </billing-address>
###  <tax-lines type='array'/>
###  <shipping-address>
###    <company nil='true'/>
###    <city>Baarn</city>
###    <address1>B. Zweerslaan 15</address1>
###    <latitude type='decimal'>52.219496</latitude>
###    <zip>3741 HL</zip>
###    <address2 nil='true'/>
###    <country>Netherlands</country>
###    <phone nil='true'/>
###    <last-name>Pikkaart</last-name>
###    <longitude type='decimal'>5.268609</longitude>
###    <province nil='true'/>
###    <first-name>Jolanda</first-name>
###    <name>Jolanda Pikkaart</name>
###    <country-code>NL</country-code>
###    <province-code nil='true'/>
###  </shipping-address>
###  <line-items type='array'>
###    <line-item>
###      <price type='decimal'>29.0</price>
###      <product-id type='integer'>43003332</product-id>
###      <title>Extra Accountability: 4 Weekly Checkins with the HabitForge Creator</title>
###      <quantity type='integer'>1</quantity>
###      <requires-shipping type='boolean'>false</requires-shipping>
###      <id type='integer'>111287682</id>
###      <grams type='integer'>0</grams>
###      <sku/>
###      <fulfillment-status nil='true'/>
###      <variant-title nil='true'/>
###      <vendor>HabitForge</vendor>
###      <fulfillment-service>manual</fulfillment-service>
###      <variant-id type='integer'>99667232</variant-id>
###      <name>Extra Accountability: 4 Weekly Checkins with the HabitForge Creator</name>
###    </line-item>
###  </line-items>
###  <shipping-lines type='array'/>
###  <note-attributes type='array'>
###  </note-attributes>
###</order>
###
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML looks like this will be an UPGRADE order w/ ref of 59105
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML searching for email of:woody12@planet.nl
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML SUCCESS order from found user woody12@planet.nl
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML About to Iterate through Line Items
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML Looking at Line Item #1
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML This Line Item is NOT for an Account Upgrade (probably Cause Credits for a Goal)
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML We weren't able to determine the goal ID for this user based
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML on the params ... trying to determine what goal it's for
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML We know that this CAUSE is for goal #96444
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML: found goal for CAUSE
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML: no such CAUSE in rails db w/ product id of 43003332
###2011-06-08 09:48:41 GMT | INFO | 46870 | XML Send email to user and CC support asking what goal to put it on
###2011-06-08 09:48:41 GMT | INFO | 46870 | Sent mail to woody12@planet.nl
###2011-06-08 09:48:44 GMT | INFO | 46870 | XML HEY WE SHOULD ACTUALLY Tell shopify that the order is fulfilled
###2011-06-08 09:48:44 GMT | INFO | 46870 | Completed in 2754ms (View: 0, DB: 2) | 200 OK [http://habitforge.com/hooks/order/create]
###2011-06-08 09:48:47 GMT | INFO | 46870 |
###
###



######################################################################################################
############ LIVE XML DUMP for SGJ CAUSE CREDIT of $1 (Red Cross) Prior to hooks being able to react fully
######################################################################################################
###Processing HooksController#create (for 67.192.100.64 at 2011-05-02 09:55:00) [POST]
###2011-05-02 14:55:00 GMT | INFO | 38624 |   Parameters: {"action"=>"create", "order"=>{"name"=>"#1254", "number"=>254, "tax_lines"=>[{"price"=>#<BigDecimal:2b879c780b78,'0.0',9(18)>, "title"=>"State Tax", "rate"=>0.05}], "line_items"=>[{"price"=>#<BigDecimal:2b879c77dbf8,'0.1E1',9(18)>, "name"=>"American Red Cross: Cause Credits ($10 increments)", "product_id"=>39685352, "requires_shipping"=>false, "title"=>"American Red Cross: Cause Credits ($10 increments)", "quantity"=>1, "id"=>102887392, "grams"=>0, "sku"=>"Cause Credits (10)", "vendor"=>"HabitForge", "variant_title"=>nil, "fulfillment_status"=>nil, "fulfillment_service"=>"manual", "variant_id"=>91473642}], "total_discounts"=>#<BigDecimal:2b879c77e4e0,'0.0',9(18)>, "created_at"=>Mon May 02 14:54:14 UTC 2011, "browser_ip"=>"96.41.228.193", "cancel_reason"=>nil, "total_price"=>#<BigDecimal:2b879c778f68,'0.1E1',9(18)>, "token"=>"26aa9b5ddbe1c260c8b5298295a7c58a", "landing_site_ref"=>nil, "updated_at"=>Mon May 02 14:54:33 UTC 2011, "landing_site"=>"/", "taxes_included"=>false, "shipping_lines"=>[], "shipping_address"=>{"name"=>"Sandon Jurowski", "address1"=>"37 Harwood Circle N", "city"=>"Madison", "company"=>nil, "address2"=>nil, "zip"=>"53717", "latitude"=>#<BigDecimal:2b879c7740d0,'0.437141E2',18(18)>, "country"=>"United States", "country_code"=>"US", "province_code"=>"WI", "last_name"=>"Jurowski", "phone"=>nil, "longitude"=>#<BigDecimal:2b879c772438,'-0.89508609E2',18(18)>, "province"=>"Wisconsin", "first_name"=>"Sandon"}, "id"=>62169282, "cancelled_at"=>nil, "order_number"=>1254, "total_line_items_price"=>#<BigDecimal:2b879c7707a0,'0.1E1',9(18)>, "referring_site"=>nil, "subtotal_price"=>#<BigDecimal:2b879c76c858,'0.1E1',9(18)>, "billing_address"=>{"name"=>"Sandon Jurowski", "address1"=>"37 Harwood Circle N", "city"=>"Madison", "company"=>nil, "address2"=>nil, "zip"=>"53717", "latitude"=>#<BigDecimal:2b879c76e9c8,'0.437141E2',18(18)>, "country"=>"United States", "country_code"=>"US", "province_code"=>"WI", "last_name"=>"Jurowski", "phone"=>nil, "longitude"=>#<BigDecimal:2b879c76d1e0,'-0.89508609E2',18(18)>, "province"=>"Wisconsin", "first_name"=>"Sandon"}, "note"=>nil, "note_attributes"=>[], "closed_at"=>nil, "buyer_accepts_marketing"=>false, "financial_status"=>"paid", "fulfillment_status"=>nil, "customer"=>{"accepts_marketing"=>false, "orders_count"=>1, "tags"=>nil, "id"=>42665082, "last_name"=>"Jurowski", "note"=>nil, "total_spent"=>#<BigDecimal:2b879c768aa0,'0.1E1',9(18)>, "first_name"=>"Sandon", "email"=>"jurowski@wisc.edu"}, "currency"=>"USD", "gateway"=>"paypal", "total_tax"=>#<BigDecimal:2b879c767a60,'0.0',9(18)>, "total_weight"=>0, "email"=>"jurowski@wisc.edu"}, "controller"=>"hooks"}
###2011-05-02 14:55:00 GMT | INFO | 38624 | Received an HF Shopify XML order file.
###2011-05-02 14:55:00 GMT | INFO | 38624 | <?xml version='1.0' encoding='UTF-8'?>
###<order>
###  <number type='integer'>254</number>
###  <name>#1254</name>
###  <created-at type='datetime'>2011-05-02T10:54:14-04:00</created-at>
###  <total-discounts type='decimal'>0.0</total-discounts>
###  <cancel-reason nil='true'/>
###  <token>26aa9b5ddbe1c260c8b5298295a7c58a</token>
###  <updated-at type='datetime'>2011-05-02T10:54:33-04:00</updated-at>
###  <total-price type='decimal'>1.0</total-price>
###  <landing-site>/</landing-site>
###  <taxes-included type='boolean'>false</taxes-included>
###  <cancelled-at type='datetime' nil='true'/>
###  <id type='integer'>62169282</id>
###  <referring-site/>
###  <total-line-items-price type='decimal'>1.0</total-line-items-price>
###  <subtotal-price type='decimal'>1.0</subtotal-price>
###  <note nil='true'/>
###  <gateway>paypal</gateway>
###  <fulfillment-status nil='true'/>
###  <financial-status>paid</financial-status>
###  <currency>USD</currency>
###  <closed-at type='datetime' nil='true'/>
###  <buyer-accepts-marketing type='boolean'>false</buyer-accepts-marketing>
###  <total-tax type='decimal'>0.0</total-tax>
###  <total-weight type='integer'>0</total-weight>
###  <email>jurowski@wisc.edu</email>
###  <browser-ip>96.41.228.193</browser-ip>
###  <landing-site-ref nil='true'/>
###  <order-number type='integer'>1254</order-number>
###  <shipping-address>
###    <company nil='true'/>
###    <city>Madison</city>
###    <address1>37 Harwood Circle N</address1>
###    <latitude type='decimal'>43.07141</latitude>
###    <zip>53717</zip>
###    <address2 nil='true'/>
###    <country>United States</country>
###    <phone nil='true'/>
###    <last-name>Jurowski</last-name>
###    <longitude type='decimal'>-89.508609</longitude>
###    <province>Wisconsin</province>
###    <first-name>Sandon</first-name>
###    <name>Sandon Jurowski</name>
###    <country-code>US</country-code>
###    <province-code>WI</province-code>
###  </shipping-address>
###  <tax-lines type='array'>
###    <tax-line>
###      <price type='decimal'>0.0</price>
###      <title>State Tax</title>
###      <rate type='float'>0.05</rate>
###    </tax-line>
###  </tax-lines>
###  <line-items type='array'>
###    <line-item>
###      <price type='decimal'>1.0</price>
###      <product-id type='integer'>39685352</product-id>
###      <title>American Red Cross: Cause Credits ($10 increments)</title>
###      <quantity type='integer'>1</quantity>
###      <requires-shipping type='boolean'>false</requires-shipping>
###      <id type='integer'>102887392</id>
###      <grams type='integer'>0</grams>
###      <sku>Cause Credits (10)</sku>
###      <fulfillment-status nil='true'/>
###      <variant-title nil='true'/>
###      <vendor>HabitForge</vendor>
###      <fulfillment-service>manual</fulfillment-service>
###      <variant-id type='integer'>91473642</variant-id>
###      <name>American Red Cross: Cause Credits ($10 increments)</name>
###    </line-item>
###  </line-items>
###  <customer>
###    <accepts-marketing type='boolean'>false</accepts-marketing>
###    <orders-count type='integer'>1</orders-count>
###    <id type='integer'>42665082</id>
###    <note nil='true'/>
###    <last-name>Jurowski</last-name>
###    <total-spent type='decimal'>1.0</total-spent>
###    <first-name>Sandon</first-name>
###    <email>jurowski@wisc.edu</email>
###    <tags/>
###  </customer>
###  <billing-address>
###    <company nil='true'/>
###    <city>Madison</city>
###    <address1>37 Harwood Circle N</address1>
###    <latitude type='decimal'>43.07141</latitude>
###    <zip>53717</zip>
###    <address2 nil='true'/>
###    <country>United States</country>
###    <phone nil='true'/>
###    <last-name>Jurowski</last-name>
###    <longitude type='decimal'>-89.508609</longitude>
###    <province>Wisconsin</province>
###    <first-name>Sandon</first-name>
###    <name>Sandon Jurowski</name>
###    <country-code>US</country-code>
###    <province-code>WI</province-code>
###  </billing-address>
###  <shipping-lines type='array'/>
###  <note-attributes type='array'>
###  </note-attributes>
###</order>
###
###2011-05-02 14:55:01 GMT | INFO | 38624 | XML searching for email of:jurowski@wisc.edu
###2011-05-02 14:55:01 GMT | INFO | 38624 | XML SUCCESS order from found user jurowski@wisc.edu
###2011-05-02 14:55:01 GMT | INFO | 38624 | XML About to Iterate through Line Items
###2011-05-02 14:55:01 GMT | INFO | 38624 | XML Looking at First Line Item
###2011-05-02 14:55:01 GMT | INFO | 38624 | XML This Line Item is NOT for an Account Upgrade (probably Cause Credits for a Goal)
###2011-05-02 14:55:01 GMT | INFO | 38624 | XML HEY WE SHOULD ACTUALLY Tell shopify that the order is fulfilled
###2011-05-02 14:55:01 GMT | INFO | 38624 | Completed in 162ms (View: 1, DB: 1) | 200 OK [http://habitforge.com/hooks/order/create]




######################################################################################################
############ LIVE XML DUMP + UPGRADE PMT FROM A PAYPAL USER W/ A DIFFERENT EMAIL THAN THEIR HF ACCOUNT
######################################################################################################
### Processing HooksController#create (for 67.192.100.64 at 2011-04-30 18:24:45) [POST]
### 2011-04-30 23:24:45 GMT | INFO | 22238 |   Parameters: {"action"=>"create", "order"=>{"name"=>"#1249", "number"=>249, "tax_lines"=>[], "line_items"=>[{"price"=>#<BigDecimal:2b2e256cc2c0,'0.999E1',18(18)>, "name"=>"12 Month Supporting Membership", "product_id"=>33131182, "requires_shipping"=>false, "title"=>"12 Month Supporting Membership", "quantity"=>1, "id"=>102562172, "grams"=>0, "sku"=>nil, "vendor"=>"HabitForge", "variant_title"=>nil, "fulfillment_status"=>nil, "fulfillment_service"=>"manual", "variant_id"=>78120792}], "total_discounts"=>#<BigDecimal:2b2e256ccc70,'0.0',9(18)>, "created_at"=>Sat Apr 30 23:24:33 UTC 2011, "browser_ip"=>"184.152.90.244", "cancel_reason"=>nil, "total_price"=>#<BigDecimal:2b2e256c8148,'0.999E1',18(18)>, "token"=>"5f80f19bd58ca92c2fd19e9d152190c0", "landing_site_ref"=>"56298", "updated_at"=>Sat Apr 30 23:24:45 UTC 2011, "landing_site"=>"/collections/frontpage/products/habitforge-supporting-membership-1-year?ref=56298", "taxes_included"=>false, "shipping_lines"=>[], "shipping_address"=>{"name"=>"france menk photography", "address1"=>"2997B Route 44/55", "city"=>"Gardiner", "company"=>"france menk photography", "address2"=>"right side porch down hill", "zip"=>"12525", "latitude"=>#<BigDecimal:2b2e256c61e0,'0.41715213E2',18(18)>, "country"=>"United States", "country_code"=>"US", "province_code"=>"NY", "last_name"=>"photography", "phone"=>nil, "longitude"=>#<BigDecimal:2b2e256c4f98,'-0.74198334E2',18(18)>, "province"=>"New York", "first_name"=>"france menk"}, "id"=>61986342, "cancelled_at"=>nil, "order_number"=>1249, "total_line_items_price"=>#<BigDecimal:2b2e256c4520,'0.999E1',18(18)>, "referring_site"=>"http://habitforge.com/goals/new", "subtotal_price"=>#<BigDecimal:2b2e256bff20,'0.999E1',18(18)>, "billing_address"=>{"name"=>"france menk photography", "address1"=>"2997B Route 44/55", "city"=>"Gardiner", "company"=>"france menk photography", "address2"=>"right side porch down hill", "zip"=>"12525", "latitude"=>#<BigDecimal:2b2e256c30d0,'0.41715213E2',18(18)>, "country"=>"United States", "country_code"=>"US", "province_code"=>"NY", "last_name"=>"photography", "phone"=>nil, "longitude"=>#<BigDecimal:2b2e256c2090,'-0.74198334E2',18(18)>, "province"=>"New York", "first_name"=>"france menk"}, "note"=>nil, "note_attributes"=>[], "closed_at"=>nil, "buyer_accepts_marketing"=>false, "financial_status"=>"paid", "fulfillment_status"=>nil, "customer"=>{"accepts_marketing"=>false, "orders_count"=>1, "tags"=>nil, "id"=>42546722, "last_name"=>"photography", "note"=>nil, "total_spent"=>#<BigDecimal:2b2e256be080,'0.999E1',18(18)>, "first_name"=>"france menk", "email"=>"iam@france-menk.com"}, "currency"=>"USD", "gateway"=>"paypal", "total_tax"=>#<BigDecimal:2b2e256bd1a8,'0.0',9(18)>, "total_weight"=>0, "email"=>"iam@france-menk.com"}, "controller"=>"hooks"}
### 2011-04-30 23:24:45 GMT | INFO | 22238 | Received an HF Shopify XML order file.
### 2011-04-30 23:24:45 GMT | INFO | 22238 | <?xml version='1.0' encoding='UTF-8'?>
### 
### 
### <order>
###   <number type='integer'>249</number>
###   <name>#1249</name>
###   <created-at type='datetime'>2011-04-30T19:24:33-04:00</created-at>
###   <total-discounts type='decimal'>0.0</total-discounts>
###   <cancel-reason nil='true'/>
###   <token>5f80f19bd58ca92c2fd19e9d152190c0</token>
###   <updated-at type='datetime'>2011-04-30T19:24:45-04:00</updated-at>
###   <total-price type='decimal'>9.99</total-price>
###   <landing-site>/collections/frontpage/products/habitforge-supporting-membership-1-year?ref=56298</landing-site>
###   <taxes-included type='boolean'>false</taxes-included>
###   <cancelled-at type='datetime' nil='true'/>
###   <id type='integer'>61986342</id>
###   <referring-site>http://habitforge.com/goals/new</referring-site>
###   <total-line-items-price type='decimal'>9.99</total-line-items-price>
###   <subtotal-price type='decimal'>9.99</subtotal-price>
###   <note nil='true'/>
###   <gateway>paypal</gateway>
###   <fulfillment-status nil='true'/>
###   <financial-status>paid</financial-status>
###   <currency>USD</currency>
###   <closed-at type='datetime' nil='true'/>
###   <buyer-accepts-marketing type='boolean'>false</buyer-accepts-marketing>
###   <total-tax type='decimal'>0.0</total-tax>
###   <total-weight type='integer'>0</total-weight>
###   <email>iam@france-menk.com</email>
###   <browser-ip>184.152.90.244</browser-ip>
###   <landing-site-ref>56298</landing-site-ref>
###   <order-number type='integer'>1249</order-number>
###   <shipping-address>
###     <company>france menk photography</company>
###     <city>Gardiner</city>
###     <address1>2997B Route 44/55</address1>
###     <latitude type='decimal'>41.715213</latitude>
###     <zip>12525</zip>
###     <address2>right side porch down hill</address2>
###     <country>United States</country>
###     <phone nil='true'/>
###     <last-name>photography</last-name>
###     <longitude type='decimal'>-74.198334</longitude>
###     <province>New York</province>
###     <first-name>france menk</first-name>
###     <name>france menk photography</name>
###     <country-code>US</country-code>
###     <province-code>NY</province-code>
###   </shipping-address>
###   <tax-lines type='array'/>
###   <line-items type='array'>
###     <line-item>
###       <price type='decimal'>9.99</price>
###       <product-id type='integer'>33131182</product-id>
###       <title>12 Month Supporting Membership</title>
###       <quantity type='integer'>1</quantity>
###       <requires-shipping type='boolean'>false</requires-shipping>
###       <id type='integer'>102562172</id>
###       <grams type='integer'>0</grams>
###       <sku/>
###       <fulfillment-status nil='true'/>
###       <variant-title nil='true'/>
###       <vendor>HabitForge</vendor>
###       <fulfillment-service>manual</fulfillment-service>
###       <variant-id type='integer'>78120792</variant-id>
###       <name>12 Month Supporting Membership</name>
###     </line-item>
###   </line-items>
###   <customer>
###     <accepts-marketing type='boolean'>false</accepts-marketing>
###     <orders-count type='integer'>1</orders-count>
###     <id type='integer'>42546722</id>
###     <note nil='true'/>
###     <last-name>photography</last-name>
###     <total-spent type='decimal'>9.99</total-spent>
###     <first-name>france menk</first-name>
###     <email>iam@france-menk.com</email>
###     <tags/>
###   </customer>
###   <billing-address>
###     <company>france menk photography</company>
###     <city>Gardiner</city>
###     <address1>2997B Route 44/55</address1>
###     <latitude type='decimal'>41.715213</latitude>
###     <zip>12525</zip>
###     <address2>right side porch down hill</address2>
###     <country>United States</country>
###     <phone nil='true'/>
###     <last-name>photography</last-name>
###     <longitude type='decimal'>-74.198334</longitude>
###     <province>New York</province>
###     <first-name>france menk</first-name>
###     <name>france menk photography</name>
###     <country-code>US</country-code>
###     <province-code>NY</province-code>
###   </billing-address>
###   <shipping-lines type='array'/>
###   <note-attributes type='array'>
###   </note-attributes>
### </order>
### 
### 2011-04-30 23:24:45 GMT | INFO | 22238 | XML searching for email of:iam@france-menk.com
### 2011-04-30 23:24:45 GMT | INFO | 22238 | XML WARN order from unknown user iam@france-menk.com...will search for user.id of 0
### 2011-04-30 23:24:45 GMT | INFO | 22238 | XML WARN order from unknown user iam@france-menk.com...will search for browser_ip of 0.0.0.0
### 2011-04-30 23:24:45 GMT | INFO | 22238 | XML NOTICE order from unknown user iam@france-menk.com and unknown user_id 0 and unknown browser_ip 0.0.0.0
### 2011-04-30 23:24:45 GMT | INFO | 22238 | XML ATTEMPTING TO SEND email to user and CC support asking what email address they use for HF
### 2011-04-30 23:24:46 GMT | INFO | 22238 | Sent mail to iam@france-menk.com
### 2011-04-30 23:24:48 GMT | INFO | 22238 | Completed in 2933ms (View: 0, DB: 306) | 200 OK [http://habitforge.com/hooks/order/create]
######################################################################################################
############ END LIVE XML DUMP + UPGRADE PMT FROM A PAYPAL USER W/ A DIFFERENT EMAIL THAN THEIR HF ACCOUNT
######################################################################################################





        #### Real XML Payment Log from Donations page
        #Processing HooksController#create (for 67.192.100.64 at 2011-04-28 17:48:49) [POST]2011-04-28 22:48:49 GMT | INFO | 12118 |   
        #Parameters: {"action"=>"create", "order"=>{"name"=>"#1244", "number"=>244, "tax_lines"=>[], 
        #    "line_items"=>[{"price"=>#<BigDecimal:2b4895a90110,'0.999E1',18(18)>, "name"=>"12 Month Supporting Membership", 
        #        "product_id"=>33131182, "requires_shipping"=>false, "title"=>"12 Month Supporting Membership", "quantity"=>1, 
        #        "id"=>102029442, "grams"=>0, "sku"=>nil, "vendor"=>"HabitForge", "variant_title"=>nil, "fulfillment_status"=>nil, 
        #        "fulfillment_service"=>"manual", "variant_id"=>78120792}], 
        #    "total_discounts"=>#<BigDecimal:2b4895a99760,'0.0',9(18)>, 
        #    "created_at"=>Thu Apr 28 22:48:19 UTC 2011, "browser_ip"=>"155.41.45.72", "cancel_reason"=>nil, 
        #    "total_price"=>#<BigDecimal:2b4895a6caa8,'0.999E1',18(18)>, "token"=>"4c42780f45e9e9205bb56db8eea6c6ca", 
        #    "landing_site_ref"=>nil, "updated_at"=>Thu Apr 28 22:48:28 UTC 2011, 
        #    "landing_site"=>"/collections/frontpage/products/habitforge-supporting-membership-1-year", "taxes_included"=>false, 
        #    "shipping_lines"=>[], "shipping_address"=>{"name"=>"Jerilyn Libby", "address1"=>"3 North Hill Drive", 
        #    "city"=>"East Northport", "company"=>nil, "address2"=>nil, "zip"=>"11731", 
        #    "latitude"=>#<BigDecimal:2b4895a5fd80,'0.40879521E2',18(18)>, "country"=>"United States", "country_code"=>"US", 
        #    "province_code"=>"NY", "last_name"=>"Libby", "phone"=>nil, 
        #    "longitude"=>#<BigDecimal:2b4895a5c478,'-0.73313118E2',18(18)>, 
        #    "province"=>"New York", "first_name"=>"Jerilyn"}, "id"=>61621782, "cancelled_at"=>nil, "order_number"=>1244, 
        #    "total_line_items_price"=>#<BigDecimal:2b4895a58490,'0.999E1',18(18)>, 
        #    "referring_site"=>"http://habitforge.com/donations.html", 
        #    "subtotal_price"=>#<BigDecimal:2b4895a4da40,'0.999E1',18(18)>, "billing_address"=>{"name"=>"Jerilyn Libby", 
        #    "address1"=>"3 North Hill Drive", "city"=>"East Northport", 
        #    "company"=>nil, "address2"=>nil, "zip"=>"11731", "latitude"=>#<BigDecimal:2b4895a53f80,'0.40879521E2',18(18)>, 
        #    "country"=>"United States", "country_code"=>"US", 
        #    "province_code"=>"NY", "last_name"=>"Libby", "phone"=>nil, 
        #    "longitude"=>#<BigDecimal:2b4895a4ff98,'-0.73313118E2',18(18)>, "province"=>"New York", 
        #    "first_name"=>"Jerilyn"}, "note"=>nil, "note_attributes"=>[], "closed_at"=>nil, 
        #    "buyer_accepts_marketing"=>false, "financial_status"=>"paid", "fulfillment_status"=>nil, 
        #    "customer"=>{"accepts_marketing"=>false, "orders_count"=>1, "tags"=>nil, "id"=>42392822, 
        #        "last_name"=>"Libby", "note"=>nil, "total_spent"=>#<BigDecimal:2b4895a43c70,'0.999E1',18(18)>, 
        #        "first_name"=>"Jerilyn", "email"=>"jerilynm@gmail.com"}, "currency"=>"USD", "gateway"=>"paypal", 
        #        "total_tax"=>#<BigDecimal:2b4895a3f468,'0.0',9(18)>, "total_weight"=>0, 
        #        "email"=>"jerilynm@gmail.com"}, "controller"=>"hooks"}
        #2011-04-28 22:48:49 GMT | INFO | 12118 | Received an HF Shopify XML order file.
        #2011-04-28 22:48:49 GMT | INFO | 12118 | XML searching for email of:jerilynm@gmail.com
        #2011-04-28 22:48:49 GMT | INFO | 12118 | XML SUCCESS order from found user jerilynm@gmail.com
        #2011-04-28 22:48:49 GMT | INFO | 12118 | XML Attempting to upgrade their account
        #2011-04-28 22:48:49 GMT | INFO | 12118 | XML SUCCESS upgrading user account for jerilynm@gmail.com
        #2011-04-28 22:48:49 GMT | INFO | 12118 | XML ATTEMPTING TO Send email to user and CC support w/ thank you and upgrade info2011-04-28 22:48:49 GMT | INFO | 12118 | Sent mail to Jerilyn<jerilynm@gmail.com>2011-04-28 22:48:51 GMT | INFO | 12118 | XML HEY WE SHOULD ACTUALLY Tell shopify that the order is fulfilled
        #2011-04-28 22:48:51 GMT | INFO | 12118 | Completed in 2188ms (View: 0, DB: 4) | 200 OK [http://habitforge.com/hooks/order/create]
        
        
        #    #### Real XML Payment Log from Goals page
        #    2011-04-01 01:07:15 GMT | INFO | 30506 |   
        #    Parameters: {"action"=>"create", "order"=>{"name"=>"#1178", "number"=>178, "tax_lines"=>[], 
        #        "line_items"=>[{"price"=>#<BigDecimal:2b3fd489bb08,'0.499E1',18(18)>, "name"=>"12 Month Supporting Membership", 
        #            "product_id"=>33131182, "requires_shipping"=>false, "title"=>"12 Month Supporting Membership", 
        #            "quantity"=>1, "id"=>95246012, "grams"=>0, "sku"=>nil, "vendor"=>"HabitForge", "variant_title"=>nil, 
        #            "fulfillment_status"=>nil, "fulfillment_service"=>"manual", "variant_id"=>78120792}], 
        #"total_discounts"=>#<BigDecimal:2b3fd489c378,'0.0',9(18)>, "created_at"=>Fri Apr 01 01:07:01 UTC 2011, 
        #"browser_ip"=>"116.0.213.218", "cancel_reason"=>nil, "total_price"=>#<BigDecimal:2b3fd4897030,'0.499E1',18(18)>, 
        #"token"=>"0b82a10ac9af4e0bdfa55c3ddd6678c2", "landing_site_ref"=>"53687", 
        #"updated_at"=>Fri Apr 01 01:07:10 UTC 2011, 
        #"landing_site"=>"/collections/frontpage/products/habitforge-supporting-membership-1-year?ref=53687", 
        #"taxes_included"=>false, "shipping_lines"=>[], 
        #"shipping_address"=>{"name"=>"Helen Kwak", "address1"=>"Jiyugaoka 3-6-2", "city"=>"Tokyo", "company"=>nil, 
        #    "address2"=>"Meguro-ku", "zip"=>"152-0035", 
        #    "latitude"=>#<BigDecimal:2b3fd488e610,'0.35610315E2',18(18)>, "country"=>"Japan", "country_code"=>"JP", 
        #    "province_code"=>nil, "last_name"=>"Kwak", "phone"=>nil, 
        #    "longitude"=>#<BigDecimal:2b3fd488d580,'0.139667328E3',18(18)>, "province"=>"Tokyo", "first_name"=>"Helen"}, 
        #"id"=>57354872, "cancelled_at"=>nil, "order_number"=>1178, 
        #"total_line_items_price"=>#<BigDecimal:2b3fd488cba8,'0.499E1',18(18)>, 
        #"referring_site"=>"http://habitforge.com/goals", "subtotal_price"=>#<BigDecimal:2b3fd4887b30,'0.499E1',18(18)>, 
        #"billing_address"=>{"name"=>"Helen Kwak", "address1"=>"Jiyugaoka 3-6-2", "city"=>"Tokyo", 
        #    "company"=>nil, "address2"=>"Meguro-ku", "zip"=>"152-0035", 
        #    "latitude"=>#<BigDecimal:2b3fd488a6c8,'0.35610315E2',18(18)>, "country"=>"Japan", 
        #    "country_code"=>"JP", "province_code"=>nil, "last_name"=>"Kwak", "phone"=>nil, 
        #    "longitude"=>#<BigDecimal:2b3fd4888170,'0.139667328E3',18(18)>, "province"=>"Tokyo", 
        #    "first_name"=>"Helen"}, 
        #"note"=>nil, "note_attributes"=>[], "closed_at"=>nil, "buyer_accepts_marketing"=>false, "financial_status"=>"paid", 
        #"fulfillment_status"=>nil, "customer"=>{"accepts_marketing"=>false, "orders_count"=>0, "tags"=>nil, "id"=>39953442, 
        #    "last_name"=>"Kwak", "note"=>nil, "total_spent"=>#<BigDecimal:2b3fd4885c90,'0.0',9(18)>, "first_name"=>"Helen", 
        #    "email"=>"kwakhelen@hotmail.com"}, "currency"=>"USD", "gateway"=>"paypal", 
        #    "total_tax"=>#<BigDecimal:2b3fd4884e80,'0.0',9(18)>, "total_weight"=>0, "email"=>"kwakhelen@hotmail.com"}, 
        #"controller"=>"hooks"}
        #2011-04-01 01:07:15 GMT | INFO | 30506 | Received an HF Shopify XML order file.
        #2011-04-01 01:07:15 GMT | INFO | 30506 | XML searching for email of:kwakhelen@hotmail.com
        #2011-04-01 01:07:15 GMT | INFO | 30506 | XML SUCCESS order from found user kwakhelen@hotmail.com
        #2011-04-01 01:07:15 GMT | INFO | 30506 | XML Attempting to upgrade their account
        #2011-04-01 01:07:15 GMT | INFO | 30506 | XML SUCCESS upgrading user account for kwakhelen@hotmail.com
        #2011-04-01 01:07:15 GMT | INFO | 30506 | XML ATTEMPTING TO Send email to user and CC support w/ thank you and upgrade info
        #2011-04-01 01:07:15 GMT | INFO | 30506 | Sent mail to Helen<kwakhelen@hotmail.com>
        #2011-04-01 01:07:18 GMT | INFO | 30506 | XML HEY WE SHOULD ACTUALLY Tell shopify that the order is fulfilled
        #2011-04-01 01:07:18 GMT | INFO | 30506 | Completed in 2301ms (View: 1, DB: 16) | 200 OK [http://habitforge.com/hooks/order/create]
        #2011-04-01 01:07:19 GMT | INFO | 30506 |        


### XML Document that gets sent in shopify test
###   Processing HooksController#create (for 67.192.100.64 at 2011-04-30 14:48:51) [POST]
###   2011-04-30 19:48:51 GMT | INFO | 9802 |   Parameters: {"action"=>"create", "controller"=>"hooks"}
###   2011-04-30 19:48:51 GMT | INFO | 9802 | Received an HF Shopify XML order file.
###   2011-04-30 19:48:51 GMT | INFO | 9802 | <?xml version='1.0' encoding='UTF-8'?>
###   <order>
###     <number type='integer'>234</number>
###     <name>#9999</name>
###     <created-at type='datetime'>2011-04-30T15:48:52-04:00</created-at>
###     <total-discounts type='decimal'>0.0</total-discounts>
###     <cancel-reason>customer</cancel-reason>
###     <token nil='true'/>
###     <updated-at type='datetime' nil='true'/>
###     <total-price type='decimal'>239.94</total-price>
###     <landing-site nil='true'/>
###     <taxes-included type='boolean'>false</taxes-included>
###     <cancelled-at type='datetime'>2011-04-30T15:48:52-04:00</cancelled-at>
###     <id type='integer'>123456</id>
###     <referring-site nil='true'/>
###     <total-line-items-price type='decimal'>229.94</total-line-items-price>
###     <subtotal-price type='decimal'>229.94</subtotal-price>
###     <note nil='true'/>
###     <gateway>bogus</gateway>
###     <fulfillment-status>pending</fulfillment-status>
###     <financial-status>voided</financial-status>
###     <currency nil='true'/>
###     <closed-at type='datetime' nil='true'/>
###     <buyer-accepts-marketing type='boolean'>true</buyer-accepts-marketing>
###     <total-tax type='decimal'>0.0</total-tax>
###     <total-weight type='integer'>0</total-weight>
###     <email>jon@doe.ca</email>
###     <browser-ip nil='true'/>
###     <landing-site-ref nil='true'/>
###     <order-number type='integer'>1234</order-number>
###     <shipping-address>
###       <company>Shipping Company</company>
###       <city>Shippington</city>
###       <address1>123 Shipping Street</address1>
###       <latitude type='decimal' nil='true'/>
###       <zip>K2P0S0</zip>
###       <address2 nil='true'/>
###       <country>Shippington Emirates</country>
###       <phone>555-555-SHIP</phone>
###       <last-name>Shipper</last-name>
###       <longitude type='decimal' nil='true'/>
###       <province>SH</province>
###       <first-name>Steve</first-name>
###       <name>Steve Shipper</name>
###       <country-code>*</country-code>
###       <province-code nil='true'/>
###     </shipping-address>
###     <tax-lines type='array'/>
###     <line-items type='array'>
###       <line-item>
###         <price type='decimal'>199.99</price>
###         <product-id type='integer' nil='true'/>
###         <title>Sledgehammer</title>
###         <quantity type='integer'>1</quantity>
###         <requires-shipping type='boolean'>true</requires-shipping>
###         <grams type='integer'>5000</grams>
###         <sku>SKU2006-001</sku>
###         <fulfillment-status nil='true'/>
###         <variant-title nil='true'/>
###         <vendor nil='true'/>
###         <fulfillment-service>manual</fulfillment-service>
###         <variant-id type='integer' nil='true'/>
###         <name>Sledgehammer</name>
###       </line-item>
###       <line-item>
###         <price type='decimal'>29.95</price>
###         <product-id type='integer' nil='true'/>
###         <title>Wire Cutter</title>
###         <quantity type='integer'>1</quantity>
###         <requires-shipping type='boolean'>true</requires-shipping>
###         <grams type='integer'>500</grams>
###         <sku>SKU2006-020</sku>
###         <fulfillment-status nil='true'/>
###         <variant-title nil='true'/>
###         <vendor nil='true'/>
###         <fulfillment-service>manual</fulfillment-service>
###         <variant-id type='integer' nil='true'/>
###         <name>Wire Cutter</name>
###       </line-item>
###     </line-items>
###     <billing-address>
###       <company>My Company</company>
###       <city>Billtown</city>
###       <address1>123 Billing Street</address1>
###       <latitude type='decimal' nil='true'/>
###       <zip>K2P0B0</zip>
###       <address2 nil='true'/>
###       <country>United Bills</country>
###       <phone>555-555-BILL</phone>
###       <last-name>Biller</last-name>
###       <longitude type='decimal' nil='true'/>
###       <province>BL</province>
###       <first-name>Bob</first-name>
###       <name>Bob Biller</name>
###       <country-code>*</country-code>
###       <province-code nil='true'/>
###     </billing-address>
###     <shipping-lines type='array'>
###       <shipping-line>
###         <price type='decimal'>10.0</price>
###         <code nil='true'/>
###         <title>Generic Shipping</title>
###       </shipping-line>
###     </shipping-lines>
###     <note-attributes type='array'>
###     </note-attributes>
###   </order>


        #### Test XML from Shopify:
        #Processing HooksController#create (for 67.192.100.64 at 2011-03-25 09:21:43) [POST]
        #2011-03-25 14:21:43 GMT | INFO | 18344 |   Parameters: {"action"=>"create", "order"=>{
        #   "name"=>"#9999", 
        #   "number"=>234, 
        #   "tax_lines"=>[], 
        #   "line_items"=>[{
        #       "price"=>#<BigDecimal:2ab08e6af248,'0.19999E3',18(18)>, 
        #       "name"=>"Sledgehammer", 
        #       "product_id"=>nil, 
        #       "requires_shipping"=>true, 
        #       "title"=>"Sledgehammer", 
        #       "quantity"=>1, 
        #       "grams"=>5000, 
        #       "sku"=>"SKU2006-001", 
        #       "vendor"=>nil, 
        #       "variant_title"=>nil, 
        #       "fulfillment_status"=>nil, 
        #       "fulfillment_service"=>"manual", 
        #       "variant_id"=>nil}, 
        #       {"price"=>#<BigDecimal:2ab08e6ac160,'0.2995E2',18(18)>, 
        #       "name"=>"Wire Cutter", 
        #       "product_id"=>nil, 
        #       "requires_shipping"=>true, 
        #       "title"=>"Wire Cutter", 
        #       "quantity"=>1, 
        #       "grams"=>500, 
        #       "sku"=>"SKU2006-020", 
        #       "vendor"=>nil, 
        #       "variant_title"=>nil, 
        #       "fulfillment_status"=>nil, 
        #       "fulfillment_service"=>"manual", 
        #       "variant_id"=>nil}], 
        #   "total_discounts"=>#<BigDecimal:2ab08e6afae0,'0.0',9(18)>, 
        #   "created_at"=>Fri Mar 25 14:21:42 UTC 2011, 
        #   "browser_ip"=>nil, 
        #   "cancel_reason"=>nil, 
        #   "total_price"=>#<BigDecimal:2ab08e6a9e60,'0.23994E3',18(18)>, 
        #   "token"=>nil, 
        #   "landing_site_ref"=>nil, 
        #   "updated_at"=>nil, 
        #   "landing_site"=>nil, 
        #   "taxes_included"=>false, 
        #   "shipping_lines"=>[{
        #       "price"=>#<BigDecimal:2ab08e69ef88,'0.1E2',9(18)>, 
        #       "code"=>nil, 
        #       "title"=>"Generic Shipping"}], 
        #   "shipping_address"=>{
        #       "name"=>"Steve Shipper", 
        #       "address1"=>"123 Shipping Street", 
        #       "city"=>"Shippington", 
        #       "company"=>"Shipping Company", 
        #       "address2"=>nil, 
        #       "zip"=>"K2P0S0", 
        #       "latitude"=>nil, 
        #       "country"=>"Shippington Emirates", 
        #       "country_code"=>"*", 
        #       "province_code"=>nil, 
        #       "last_name"=>"Shipper", 
        #       "phone"=>"555-555-SHIP", 
        #       "longitude"=>nil, 
        #       "province"=>"SH", 
        #       "first_name"=>"Steve"}, 
        #   "id"=>123456, 
        #   "cancelled_at"=>nil, 
        #   "order_number"=>1234, 
        #   "total_line_items_price"=>#<BigDecimal:2ab08e696428,'0.22994E3',18(18)>, 
        #   "referring_site"=>nil, 
        #   "subtotal_price"=>#<BigDecimal:2ab08e689d18,'0.22994E3',18(18)>, 
        #   "billing_address"=>{
        #       "name"=>"Bob Biller", 
        #       "address1"=>"123 Billing Street", 
        #       "city"=>"Billtown", 
        #       "company"=>"My Company", 
        #       "address2"=>nil, 
        #       "zip"=>"K2P0B0", 
        #       "latitude"=>nil, 
        #       "country"=>"United Bills", 
        #       "country_code"=>"*", 
        #       "province_code"=>nil, 
        #       "last_name"=>"Biller", 
        #       "phone"=>"555-555-BILL", 
        #       "longitude"=>nil, 
        #       "province"=>"BL", 
        #       "first_name"=>"Bob"}, 
        #   "note"=>nil, 
        #   "note_attributes"=>[], 
        #   "closed_at"=>nil, 
        #   "buyer_accepts_marketing"=>true, 
        #   "financial_status"=>"pending", 
        #   "fulfillment_status"=>"pending", 
        #   "currency"=>nil, 
        #   "gateway"=>"bogus", 
        #   "total_tax"=>#<BigDecimal:2ab08e688580,'0.0',9(18)>, 
        #   "total_weight"=>0, 
        #   "email"=>"jon@doe.ca"}, 
        #   "controller"=>"hooks"}
        #2011-03-25 14:21:43 GMT | INFO | 18344 | Received an HF Shopify XML order file.
        #2011-03-25 14:21:43 GMT | INFO | 18344 | Completed in 12ms (View: 0, DB: 0) | 403 Forbidden [http://habitforge.com/hooks/order/create]

        

        ##Check if the customer accepts marketing
        #if doc.elements["order/buyer-accepts-marketing"].text == "true" 
        #  #Retrieve the customer's details
        #  email = doc.elements["order/email"].text
        #  name = doc.elements["order/billing-address/name"].text
        #
        #  #Add the customer to the Campaign Monitor subscriber list
        #  begin
        #    Net::HTTP.post_form(URI.parse('http://api.createsend.com/api/api.asmx/Subscriber.Add'),
        #      {'ApiKey' => ' ** Campaign Monitor Api Key ** ',
        #      'ListID' => ' ** Campaign Monitor ListID ** ',
        #      'Email' => email,
        #      'Name' => name})
        #
        #    #Return 200 OK
        #    status = 200
        #  rescue
        #    #Return 500 Internal Error
        #    status = 500
        #  end
        #end
