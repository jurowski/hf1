

  def quicksignup_v2
    logger.info("sgj:users_controller:quicksignup_v2:1")
    @form_submitted = false
    @email_submitted = false
    @email_duplicate = false
    @email_blank = false
    @email_valid = false
    @account_created = false

    if params[:form_submitted]
      @form_submitted = true
    end
    if params[:email] and params[:email] == ""
      @email_blank = true
    end 
    if params[:email] and params[:email] != ""
      @email_submitted = true
    end

    if @email_submitted
      if valid_email(params[:email])
        @email_valid = true
      end
    end

    logger.info("sgj:users_controller:quicksignup_v2:2")

    if @email_valid
      ### validate email
      user = User.find(:first, :conditions => "email = '#{params[:email]}'")
      if user != nil
        @email_duplicate = true
      end
    end ### end if email_submitted


    logger.info("sgj:users_controller:quicksignup_v2:3")

    if @email_duplicate
      ### ask the user to enter a new email address or log in w/ the existing one

      logger.info("sgj:users_controller:quicksignup_v2:3.5")

      if params[:invitation_id]
        redirect_url_string = "/user_session/new?skip_intro=1&message=invitation_existing_email"
        redirect_to(redirect_url_string)
      end
      
    else

      logger.info("sgj:users_controller:quicksignup_v2:4")

      user = User.new

      if params[:to_name]
        user.first_name = params[:to_name]
      else
        user.first_name = "unknown"
      end

      user.last_name = ""
      if session[:referer] != nil
        user.referer = session[:referer]
      end
      user.email = params[:email]
      user.email_confirmation = params[:email]
      random_pw_number = rand(1000) + 1 #between 1 and 1000
      user.password = "xty" + random_pw_number.to_s
      user.password_confirmation = user.password
      user.password_temp = user.password
      user.sponsor = "habitforge"
      user.time_zone = "Central Time (US & Canada)"
      ### having periods in the first name kills the attempts to email that person, so remove periods
      user.first_name = user.first_name.gsub(".", "")

      if session[:affiliate_name] != nil and session[:affiliate_name] != ""
        affiliate = Affiliate.find(:first, :conditions => "affiliate_name = '#{session[:affiliate_name]}'")
        if affiliate
          user.affiliate = affiliate
        end
      end



      ### Setting this to something other than 0 so that this person
      ### is included in the next morning's cron job to send emails
      ### this will get reset to the right number once each day via cron
      ### but set it now in case user is being created after that job runs
      user.update_number_active_goals = 1

      ### update last activity date
      user.last_activity_date = user.dtoday

      user.date_of_signup = user.dtoday


      ### IF THEY ARE A NEWLY PAID USER
      if params[:ga_goal]
        session[:sfm_virgin] = false ### they are a newly paid user          
        user.kill_ads_until = "3000-01-01"
        user.unlimited_goals = true
      end

      logger.info("sgj:users_controller:quicksignup_v2:5")

      if user.save 

        if params[:signup_intent_paid]
          logger.info("sgj:users_controller:quicksignup_v2: PAID USER INTENT")
        else
          logger.info("sgj:users_controller:quicksignup_v2: FREE USER INTENT")
        end


        logger.info("sgj:users_controller:quicksignup_v2:5.1")
        begin

          ### SET ANY FB ITEMS ####
          if session[:fb_id]
            user.fb_id = session[:fb_id].to_i
          end
          if session[:fb_email]
            user.fb_email = session[:fb_email]
          end
          if session[:fb_username]
            user.fb_username = session[:fb_username]
          end
          if session[:fb_first_name]
            user.fb_first_name = session[:fb_first_name]
            user.first_name = user.fb_first_name
          end
          logger.info("sgj:users_controller:quicksignup_v2:5.15")          
          if session[:fb_last_name]
            user.fb_last_name = session[:fb_last_name]
            ### do not copy this over w/out their permission
          end
          if session[:fb_gender]
            user.fb_gender = session[:fb_gender]
            ### do not copy this over w/out their permission
          end
          if session[:fb_timezone]
            user.fb_timezone = session[:fb_timezone].to_s
          end
          logger.info("sgj:users_controller:quicksignup_v2:5.2")

          #### ALLOW FOR EMAIL ADDRESS CONFIRMATION
          random_confirm_token = rand(1000) + 1 #between 1 and 1000
          user.confirmed_address_token = "xtynzsc" + random_confirm_token.to_s
          user.save
          #### now that we have saved and have the user id, we can send the email 
          the_subject = "Confirm your HabitForge Subscription"
          #if Rails.env.production?
          logger.error("sgj:users_controller:create:about to send user confirmation to user " + user.email)
            Notifier.deliver_user_confirm(user, the_subject) # sends the email
          #end
        rescue
          logger.error("sgj:email confirmation for user creation did not send")
        end
      

        stats_increment_new_user

        ### do something like the below once we know what their goal is
        #@user = user
        #Notifier.deliver_widget_user_creation(@user) # sends the email


        ### IF THEY ARE NOT A NEWLY PAID USER
        if !params[:ga_goal]
          session[:sfm_virgin] = true ### they are setting up their first goal ... allows you to hide or show certain things
        end

        session[:sfm_virgin_need_to_confirm_timezone] = true
        session[:sfm_virgin_need_to_email_temp_password] = true
        @account_created = true

        if @production
          begin	
  	        #####################################################
  	        #####################################################
        		#### CREATE A CONTACT FOR THEM IN INFUSIONSOFT ######
            ### SANDBOX GROUP/TAG IDS
        		#112: hf new signup funnel v2 free no goal yet
        		#120: hf new signup funnel v2 free created goal
            #
            ### PRODUCTION GROUP/TAG IDS
            #400: hf new signup funnel v2 free no goal yet
            #398: hf new signup funnel v2 free created goal

            # USERVOICE TICKET#529:
            #103: add to ETR "Newsletter Subscriber"

            if Rails.env.production?
              session[:infusionsoft_contact_id] = 0
          		new_contact_id = Infusionsoft.contact_add({:FirstName => user.first_name, :LastName => user.last_name, :Email => user.email})
          		Infusionsoft.email_optin(user.email, 'HabitForge signup')
          		Infusionsoft.contact_add_to_group(new_contact_id, 400)

              if params[:subscribe_etr]
                Infusionsoft.contact_add_to_group(new_contact_id, 103)
                logger.error("sgj:users_controller:YES user chose to be an etr newsletter subscriber")      
              else
                logger.error("sgj:users_controller:NO user chose not to be an etr newsletter subscriber")      
              end

          		session[:infusionsoft_contact_id] = new_contact_id
            end
  	        ####          END INFUSIONSOFT CONTACT           ####
  	        #####################################################
  	        #####################################################
          rescue
        	  logger.error("sgj:users_controller:error creating infusionsoft contact")
          end
        end ## if production

        ############## ADD THEM TO FOLLOWUP SEQUENCE
        ############## http://help.infusionsoft.com/api-docs/funnelservice

        logger.info("sgj:users_controller:quicksignup_v2:6")

        ### IF THEY ARE NOT A NEWLY PAID USER
        if !params[:ga_goal]
          begin

            logger.info("sgj:users_controller:will try adding to infusionsoft followup funnel sequence the infusionsoft_contact_id: " + session[:infusionsoft_contact_id].to_s + " for current_user.id of " + current_user.id.to_s)

            if Rails.env.production?

              ### TRY #1
              ############## http://stackoverflow.com/questions/629632/ruby-posting-xml-to-restful-web-service-using-nethttppost        
              #url = URI.parse('http://sdc90018.infusionsoft.com:80')
              #request = Net::HTTP::Post.new(url.path)
              # request = Net::HTTP::Post.new("https://sdc90018.infusionsoft.com/api/xmlrpc")
              # request.use_ssl = true
              # request.content_type = 'text/xml'
              # request.body = "<?xml version='1.0' encoding='UTF-8'?>\
              # <methodCall>\
              # <methodName>FunnelService.achieveGoal</methodName>\
              # <params>\
              # <param><value><string>d541e86effd15eb57f1f9f6344fc8eee</string></value></param>\
              # <param><value><string>sdc90018</string></value></param>\
              # <param><value><string>HabitForgeFollowUp</string></value></param>\
              # <param><value><int>#{session[:infusionsoft_contact_id]}</int></value></param>\
              # </params>\
              # </methodCall>"
              # #response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
              # response = Net::HTTP.start("sdc90018.infusionsoft.com", 80) {|http| http.request(request)}
              # assert_equal '201 Created', response.get_fields('Status')[0]

              ### TRY #2
              ### http://www.ruby-forum.com/topic/121529
              #require 'net/https'
              #require 'uri'
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
              <param><value><int>#{session[:infusionsoft_contact_id]}</int></value></param>\
              </params>\
              </methodCall>"
              headers = {'Content-Type' => 'text/xml'}
              # warning, uri.path will drop queries, use uri.path + uri.query if you need to
              resp, body = http.post(uri.path, data, headers)

              logger.info("sgj:users_controller:xml response from adding new person to infusionsoft sequence: " + resp.to_s + body.to_s)
            end
          rescue
            logger.error("sgj:users_controller:error adding to infusionsoft followup funnel sequence")
          end
        end ### end whether they are a newly paid user


        ### grab these vars from the URL so they are available on goal creation
        if params[:template_user_parent_goal_id]
          session[:template_user_parent_goal_id] = params[:template_user_parent_goal_id]
        end
        if params[:goal_added_through_template_from_program_id]
          session[:goal_added_through_template_from_program_id] = params[:goal_added_through_template_from_program_id].to_i
        end

        ### responding to a valid invitation ?

        ###http://localhost:3000/quicksignup_v2?invitation_id=34&email=jurowski@pediatrics.wisc.edu&to_name=SJ&form_submitted=1&category=Exercise&template_user_parent_goal_id=127454&goal_template_text=walking%20a%20lot
        if params[:invitation_id]
          logger.info("sgj:users_controller:quicksignup_v2:answering invitation:1")
          invite = Invite.find(params[:invitation_id].to_i)
          logger.info("sgj:users_controller:quicksignup_v2:answering invitation:1.2")
          if invite
            logger.info("sgj:users_controller:quicksignup_v2:answering invitation:2")
            if invite.to_email == user.email
              logger.info("sgj:users_controller:quicksignup_v2:answering invitation:3")
              session[:accepting_invitation_id] = params[:invitation_id].to_i

              ###### REDIRECT TO A NEW GOAL MATCHING THE TEAM YOU'RE INVITED TO
              redirect_url_string = "/goals/new?welcome=1"
              if params[:invitation_id]
                redirect_url_string += "&invitation_id=" + params[:invitation_id]
              end
              if params[:category]
                redirect_url_string += "&category=" + params[:category]
              end
              if params[:template_user_parent_goal_id]
                redirect_url_string += "&template_user_parent_goal_id=" + params[:template_user_parent_goal_id]
              end
              if params[:goal_template_text]
                redirect_url_string += "&goal_template_text=" + params[:goal_template_text]
                #goal_template_text = "&goal_template_text=" + params[:goal_template_text]
              end
              logger.info("sgj:users_controller:quicksignup_v2:answering invitation:1")

              logger.info("sgj:users_controller:quicksignup_v2:answering invitation:ABOUT TO REDIRECT TO:" + redirect_url_string)


              @redirect_after_invite_response = true

              logger.info("sgj:users_controller:quicksignup_v2:answering invitation:1")

            end
          end
        end


        if !@redirect_after_invite_response
          ### IF THEY ARE NOT A NEWLY PAID USER
          if !params[:ga_goal]

            ### if their intent on initial signup was to pay
            if params[:signup_intent_paid]
              redirect_url_string = "https://www.securepublications.com/habit-gse3.php?ref=" + user.id.to_s + "&email=" + user.email
            else
              ### route them to goal creation page (which should reference session[:sfm] for quick goal-creation options)
              #redirect_to("/goals/new?welcome=1")
              redirect_url_string = "/goals/new?welcome=1"

              ###### REDIRECT TO A NEW GOAL MATCHING THE PARAMS ENTERED
              if params[:category]
                redirect_url_string += "&category=" + params[:category]
              end
              if params[:template_user_parent_goal_id]
                redirect_url_string += "&template_user_parent_goal_id=" + params[:template_user_parent_goal_id]
              end
              if params[:goal_template_text]
                redirect_url_string += "&goal_template_text=" + params[:goal_template_text]
              end

            end

          else
            #redirect_to("/goals")
            redirect_url_string = "/goals"
          end
        end
        redirect_to(redirect_url_string)


      else
        ### Problem saving user: ask them to contact support
      end ### end if user.save

    end ### end if not duplicate email


  end ### end def quicksignup_v2

