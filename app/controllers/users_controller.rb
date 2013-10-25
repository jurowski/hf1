require "mail"

### for sending xml to infusionsoft
require 'net/https'
require 'uri'

### for gravatar
### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
require 'digest/md5'

class UsersController < ApplicationController
  layout "application"

  # GET /users
  # GET /users.xml


  ### Do you want to be able to create new users when someone is logged in?
  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_no_user, :only => [:quicksignup_v2]
  before_filter :require_user, :only => [:show, :edit, :update, :index, :destroy]
  #before_filter :require_user, :only => [:show, :edit, :update]


  def stats_increment_new_user

      ### GET DATE NOW ###
      jump_forward_days = 0

      tnow = Time.now
      tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
      tnow_m = tnow.strftime("%m").to_i #month of the year
      tnow_d = tnow.strftime("%d").to_i #day of the month
      tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
      tnow_M = tnow.strftime("%M").to_i #minute of the hour
      #puts tnow_Y + tnow_m + tnow_d  
      puts "Current timestamp is #{tnow.to_s}"
      dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
      dyesterday = dnow - 1
      d2daysago = dnow - 2
      ######


      @stats = Stat.find(:all, :conditions => "recorddate = '#{get_dnow}' and recordhour = '#{tnow_H}'")

      @stat = Stat.new
      if @stats.size > 0
        for stat in @stats
          @stat =  stat
        end
      end
      @stat.recorddate = dnow
      @stat.recordhour = tnow_H


      #######
      # enter actions here
      #######

      if @stat.usersnewcreated == nil
        @stat.usersnewcreated = 0
      end
      @stat.usersnewcreated = @stat.usersnewcreated + 1

      #######
      # end actions
      #######

      @stat.save
  end

  def valid_email( value )
    begin
     return false if value == ''
     parsed = Mail::Address.new( value )
     return parsed.address == value && parsed.local != parsed.address
    rescue Mail::Field::ParseError
      return false
    end
  end

  def get_dnow
    ### GET DATE NOW ###
    jump_forward_days = 0

    if current_user
      Time.zone = current_user.time_zone
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
    return dnow
  end  
    
  
  
  def tell_a_friend
    @user = @current_user
  end

  def index

    if params[:impersonate]
      redirect_to("/goals")
    else


        ############# MANUALLY CONFIRM AN ACCOUNT ############################
        if current_user_is_admin and params[:confirm_id]
            user = User.find(:first, :conditions => "id = #{params[:confirm_id].to_i}") 
            if user != nil
              user.confirmed_address = true

              if user.save
                  logger.info 'HF SUCCESS confirming user account for ' + user.email
              else 
                  logger.info 'HF ERROR confirming user account for ' + user.email
              end

            end
        end        



        ############# MANUALLY UPGRADE AN ACCOUNT ############################
        if current_user_is_admin and params[:upgrade_id]
            ### GET DATE NOW ###
            jump_forward_days = 0
            tnow = Time.now
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
            logger.info 'HF Attempting to upgrade their account'

            user = User.find(:first, :conditions => "id = #{params[:upgrade_id].to_i}") 
            if user != nil
                days = 365
                if params[:days]
		              days = params[:days].to_i
                end

                if user.supportpoints and user.supportpoints >= 100
                  user.supportpoints = user.supportpoints - 100
                end
                user.combine_daily_emails = 0
                user.hide_donation_plea = 1
                user.unlimited_goals = 1
                user.kill_ads_until = dnow + days
                user.sent_expire_warning_on = '1900-01-01'
            
                # if user.payments == nil
                #     user.payments = 0.0
                # end
                # user.payments = user.payments + 10.00
                # user.last_donation_date = dnow
                user.got_free_membership = dnow
                if user.save
                    logger.info 'HF SUCCESS upgrading user account for ' + user.email

                    ### Send email to user and CC support w/ thank you and upgrade info
                    logger.info 'HF ATTEMPTING TO Send email to user and CC support w/ thank you and upgrade info'
                    Notifier.deliver_user_upgrade_notification(user) # sends the email
                else 
                    logger.info 'HF ERROR upgrading user account for ' + user.email
                end


            end
        end






        #### FORITTO BE
        if  current_user.email == "sanjeev@ontrackrealty.com" or current_user.email == "jurowski@gmail.com" or current_user.email == "toyajohn2@yahoo.com" or current_user.email == "sam@marriageinsiders.com"
            skinned_admin = true
        else
            skinned_admin = false
        end
        #### END FORITTO BE

        if current_user_is_admin
            #### ALL USERS REGARDLESS OF SPONSOR
            if params[:search_for]
              @users = User.find(:all, :conditions => "first_name like '%#{params[:search_for]}%' or last_name like '%#{params[:search_for]}%' or email like '%#{params[:search_for]}%'", :order => "id DESC")
            else
              @users = User.find(:all, :conditions => "id = #{@current_user.id}")
            end
        else
            if current_user.email == "sanjeev@ontrackrealty.com" or current_user.email == "jurowski@gmail.com"
                #### FORITTOBE ###########
                if params[:search_for]
                  @users = User.find(:all, :conditions => "(first_name like '%#{params[:search_for]}%' or last_name like '%#{params[:search_for]}%' or email like '%#{params[:search_for]}%') and sponsor like '%forittobe%'", :order => "id DESC")
                else
                  @users = User.find(:all, :conditions => "id = #{@current_user.id} and sponsor like '%forittobe%'")
                end
                ###### END FORITTOBE ###########
            end
            if current_user.email == "toyajohn2@yahoo.com" or current_user.email == "sam@marriageinsiders.com"
                #### MARRIAGEREMINDERS ###########
                if params[:search_for]
                  @users = User.find(:all, :conditions => "(first_name like '%#{params[:search_for]}%' or last_name like '%#{params[:search_for]}%' or email like '%#{params[:search_for]}%') and sponsor like '%marriagereminders%'", :order => "id DESC")
                else
                  @users = User.find(:all, :conditions => "id = #{@current_user.id} and sponsor like '%marriagereminders%'")
                end
                ###### END MARRIAGEREMINDERS ###########
            end
        end

    


        if current_user_is_admin or skinned_admin == true
            respond_to do |format|
              format.html #index.html.erb
              format.xml  { render :xml => @users }
            end
        else
        
            #@users = User.find(:all, :conditions => "id = #{@current_user.id}")
            ###########
            #### CREATE TEST DATA IF NONE EXISTS
            if @users.size == 0

              u = User.new
              u.email = "jurowski@gmail.com"
              u.first_name = "Sandon"
              u.last_name = "Jurowski"
              u.password = "abcd1234"
              u.password_confirmation = "abcd1234"
              u.save

              u = User.new
              u.email = "jurowski1@gmail.com"
              u.first_name = "Ryan"
              u.last_name = "Ehmen"
              u.password = "abcd1234"
              u.password_confirmation = "abcd1234"
              u.save

              u = User.new
              u.email = "jurowski2@gmail.com"
              u.first_name = "Admin"
              u.last_name = "Admin"
              u.password = "abcd1234"
              u.password_confirmation = "abcd1234"
              u.save

            end
            ###########

          redirect_to("/goals")
  
        end

    end

  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = @current_user


      if params[:set_combine_daily_emails]=="1"
        current_user.combine_daily_emails = 1
        current_user.save
      end
      if params[:set_combine_daily_emails]=="0"
        current_user.combine_daily_emails = 0
        current_user.save
      end


    #@user = User.find(params[:id])
    #
    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.xml  { render :xml => @user }
    #end
  end
  def quicksignup_v2
    logger.debug("sgj:users_controller:quicksignup_v2:1")
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

    logger.debug("sgj:users_controller:quicksignup_v2:2")

    if @email_valid
      ### validate email
      user = User.find(:first, :conditions => "email = '#{params[:email]}'")
      if user != nil
        @email_duplicate = true
      end
    end ### end if email_submitted


    logger.debug("sgj:users_controller:quicksignup_v2:3")

    if @email_duplicate
      ### ask the user to enter a new email address or log in w/ the existing one

      logger.debug("sgj:users_controller:quicksignup_v2:3.5")

      if params[:invitation_id]
        redirect_url_string = "/user_session/new?skip_intro=1&message=invitation_existing_email"
        redirect_to(redirect_url_string)
      end
      
    else

      logger.debug("sgj:users_controller:quicksignup_v2:4")

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

      logger.debug("sgj:users_controller:quicksignup_v2:5")

      if user.save 

        if params[:signup_intent_paid]
          logger.debug("sgj:users_controller:quicksignup_v2: PAID USER INTENT")
        else
          logger.debug("sgj:users_controller:quicksignup_v2: FREE USER INTENT")
        end

        begin

          ### SET ANY FB ITEMS ####
          if session[:fb_id]
            user.fb_id = session[:fb_id]
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
          if session[:fb_last_name]
            user.fb_last_name = session[:fb_last_name]
            ### do not copy this over w/out their permission
          end
          if session[:fb_gender]
            user.fb_gender = session[:fb_gender]
            ### do not copy this over w/out their permission
          end
          if session[:fb_timezone]
            user.fb_timezone = session[:fb_timezone]
          end

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

        logger.debug("sgj:users_controller:quicksignup_v2:6")

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
          logger.debug("sgj:users_controller:quicksignup_v2:answering invitation:1")
          invite = Invite.find(params[:invitation_id].to_i)
          logger.debug("sgj:users_controller:quicksignup_v2:answering invitation:1.2")
          if invite
            logger.debug("sgj:users_controller:quicksignup_v2:answering invitation:2")
            if invite.to_email == user.email
              logger.debug("sgj:users_controller:quicksignup_v2:answering invitation:3")
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
              logger.debug("sgj:users_controller:quicksignup_v2:answering invitation:1")

              logger.info("sgj:users_controller:quicksignup_v2:answering invitation:ABOUT TO REDIRECT TO:" + redirect_url_string)


              @redirect_after_invite_response = true

              logger.debug("sgj:users_controller:quicksignup_v2:answering invitation:1")

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


  end

  # GET /users/new
  # GET /users/new.xml
  def new

    redirect_me = false
    if !request.domain.include? 'mylearninghabit' and !request.domain.include? 'forittobe'
      redirect_me = true
      #redirect_to("/")
    end

    @user = User.new


    if session[:affiliate_name] != nil and session[:affiliate_name] != ""
     @affiliate = Affiliate.find(:first, :conditions => "affiliate_name = '#{session[:affiliate_name]}'")
      if @affiliate
          @user.affiliate = @affiliate
      end
    end

    @user.yob = 1980

    if redirect_me
      redirect_to("/")
    else
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @user }
      end
    end

  end


  # GET /users/1/edit
  def edit
    #@user = User.find(params[:id])
    #@user = @current_user


    if current_user_is_admin
      ### edit current user
      @user = User.find(params[:id])
    else
      @user = @current_user # makes our views "cleaner" and more consistent      
    end

  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    if @user.time_zone == nil
      @user.time_zone = "Central Time (US & Canada)"
      session[:sfm_virgin_need_to_confirm_timezone] = true
    end

    if session[:referer] != nil
      @user.referer = session[:referer]
    end
    
    ### having periods in the first name kills the attempts to email that person, so remove periods
    @user.first_name = @user.first_name.gsub(".", "")

    if session[:sponsor] != nil and session[:sponsor] != "" 
    else
      session[:sponsor] = "habitforge"
    end
    @user.sponsor = session[:sponsor]

    if session[:affiliate_name] != nil and session[:affiliate_name] != "" 
      affiliate = Affiliate.find(:first, :conditions => "affiliate_name = '#{session[:affiliate_name]}'")
      if affiliate
          @user.affiliate = affiliate
      end
    end

    
    ### Setting this to something other than 0 so that this person
    ### is included in the next morning's cron job to send emails
    ### this will get reset to the right number once each day via cron
    ### but set it now in case user is being created after that job runs
    @user.update_number_active_goals = 1

    ### update last activity date
    @user.last_activity_date = @user.dtoday


    #### ALLOW FOR EMAIL ADDRESS CONFIRMATION
    random_confirm_token = rand(1000) + 1 #between 1 and 1000
    @user.confirmed_address_token = "xtynzsc" + random_confirm_token.to_s
    if @user.save


      flash[:notice] = "Account registered!"
     
      #### now that we have saved and have the user id, we can send the email 
      the_subject = "Confirm your HabitForge Subscription"
      begin
        #if Rails.env.production?
          logger.error("sgj:users_controller:create:about to send user confirmation to user " + @user.email)
          Notifier.deliver_user_confirm(@user, the_subject) # sends the email
        #end
      rescue
        logger.error("sgj:email confirmation for user creation did not send")
      end
      

      ### FIELDS
      #stat recorddate:date recordhour:integer usercount:integer goalcount:integer goalactivecount:integer goalsnewcreated:integer usersnewcreated:integer checkpointemailssent:integer

      stats_increment_new_user
      
      #Notifier.deliver_signup_notification(@user) # sends the email
      
      if params[:account_type] and params[:account_type] == "supporting"
          #redirect_to("http://habitforge.myshopify.com/collections/frontpage/products/habitforge-supporting-membership-1-year?ref=#{@user.id.to_s}")

          if Rails.env.production?
            redirect_to("https://www.securepublications.com/habit-1-year.php?ref=#{@user.id.to_s}&email=#{@user.email}")
          else
            session[:dev_mode_just_returned_from_sales_page] = true
            format.html {redirect_to("/goals/new?dev_mode_just_returned_from_sales_page=1")}
          end


      else
          redirect_to("/goals/new")
      end

    else
      render :action => :new
    end
    #@user = User.new(params[:user])
    #
    #respond_to do |format|
    #  if @user.save
    #    flash[:notice] = 'User was successfully created.'
    #
    #    Notifier.deliver_signup_notification(@user) # sends the email
    #
    #    format.html { redirect_to(@user) }
    #    format.xml  { render :xml => @user, :status => :created, :location => @user }
    #  else
    #    format.html { render :action => "new" }
    #    format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
    #  end
    #end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update

    if current_user_is_admin
      ### edit current user
      @user = User.find(params[:id])
    else
      @user = @current_user # makes our views "cleaner" and more consistent      
    end
    

    email_original = @user.email




    ### having periods in the first name kills the attempts to email that person, so remove periods
    @user.first_name = @user.first_name.gsub(".", "")
    
    if @user.update_attributes(params[:user])

      if session[:sfm_virgin_need_to_confirm_timezone]
        session[:sfm_virgin_need_to_confirm_timezone] = false
      end


      ### update last activity date
      @user.last_activity_date = @user.dtoday

      @user.password_temp = ""

      ### yes we'd like to kill off email_confirmation field,
      ### but lack of DRY makes us not want to
      ### so here's a workadound that won't break signup spots
      @user.email_confirmation = @user.email

      @user.save

      email_now = @user.email


      #####################################################
      #####################################################
      ##### update their email address in InfusionSoft
      if Rails.env.production?
        begin 
          logger.info("sgj:users_controller:will attempt to update their email address in infusionsoft")
          ### https://github.com/nateleavitt/infusionsoft/pull/9
          ### Usage:
          ###    selected_fields = ['Id', 'FirstName', 'LastName']
          ###    contact = Infusionsoft.contact_find_by_email('user@example.com', selected_fields)
          selected_fields = ['Id']
          contact = Infusionsoft.contact_find_by_email(email_original, selected_fields)
          if contact
            Infusionsoft.contact_update(contact[0], { :Email => email_now})
            logger.info("sgj:users_controller:success updating user email in infusionsoft from " + email_original + " to " + email_now )
          else
            logger.error("sgj:users_controller:could not find infusionsoft user " + email_original )
          end


        rescue
          logger.error("sgj:users_controller:error opting-out infusionsoft contact")
        end
      else
          logger.info("sgj:users_controller:in production we would have attempted to opt-out infusionsoft contact")          
      end
      ####          END udpate their email address in INFUSIONSOFT  ####
      #####################################################
      #####################################################















      #### since we save cheers by email address, update it when that changes
      if email_original != email_now
        my_cheers = Cheer.find(:all, :conditions => "email = '#{email_original}'")
        my_cheers.each do |cheer|
          cheer.email = email_now
          cheer.save
        end
      end


      @goals = Goal.find(:all, :conditions => "user_id = '#{@user.id}'")
      for goal in @goals
        puts "_______________"

        #if goal.user.email == "jurowski@gmail.com" or goal.user.email == "jurowski@pediatrics.wisc.edu"
	#  puts "___ testing custom user send hour, so not assigning usersendhour here unless nil"
          if goal.usersendhour == nil
	    goal.usersendhour = 1
          end
        #else
        #  goal.usersendhour = 1
	#end

        Time.zone = goal.user.time_zone
        utcoffset = Time.zone.formatted_offset(false)
        offset_seconds = Time.zone.now.gmt_offset 

        send_time = Time.utc(2000, "jan", 1, goal.usersendhour, 0, 0) #2000-01-01 01:00:00 UTC
        central_time_offset = 21600 #add this in since we're doing UTC
        server_time = send_time - offset_seconds - central_time_offset

        puts "User lives in #{goal.user.time_zone} timezone, UTC offset of #{utcoffset} (#{offset_seconds} seconds)." #Save this value in each goal, and use that to do checkpoint searches w/ cronjob
        puts "For them to get an email at #{send_time.strftime('%k')} their time, the server would have to send it at #{server_time.strftime('%k')} Central time"
        goal.serversendhour = server_time.strftime('%k')
        goal.gmtoffset = utcoffset
        goal.save
      end

      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
    #@user = User.find(params[:id])
    #
    #respond_to do |format|
    #  if @user.update_attributes(params[:user])
    #    flash[:notice] = 'User was successfully updated.'
    #    format.html { redirect_to(@user) }
    #    format.xml  { head :ok }
    #  else
    #    format.html { render :action => "edit" }
    #    format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])

    session[:single_login] = nil

    destroy_me = false

    if current_user_is_admin
        destroy_me = true
    else
      if @current_user.id == @user.id
        destroy_me = true
      else
        ### A non-admin is trying to delete an account that is not their own
      end
    end
  
    if destroy_me == true



        #####################################################
        #####################################################
        #### Add them to an OPT OUT group IN INFUSIONSOFT ######
        if Rails.env.production?
          begin 
            #
            ### PRODUCTION GROUP/TAG IDS
            #291: OPT-OUT

            logger.info("sgj:users_controller:will attempt to opt-out infusionsoft contact")
            ### https://github.com/nateleavitt/infusionsoft/pull/9
            ### Usage:
            ###    selected_fields = ['Id', 'FirstName', 'LastName']
            ###    contact = Infusionsoft.contact_find_by_email('user@example.com', selected_fields)
            selected_fields = ['Id']
            contact = Infusionsoft.contact_find_by_email(@user.email, selected_fields)
            if contact
              Infusionsoft.contact_add_to_group(contact[0], 291)
              logger.info("sgj:users_controller:success removing " + @user.email + " from infusionsoft (added them to OPT-OUT group 291")
            else
              logger.error("sgj:users_controller:could not find infusionsoft user " + @user.email + " to OPT-OUT")
            end
          rescue
            logger.error("sgj:users_controller:error opting-out infusionsoft contact")
          end
        else
            logger.info("sgj:users_controller:in production we would have attempted to opt-out infusionsoft contact")          
        end
        ####          END INFUSIONSOFT OPT-OUT CONTACT   ####
        #####################################################
        #####################################################



        ### do not delete user account, just put "xxx_date" in front of email so we have a history
        #@user.email = "xxx_" + get_dnow.to_s + "_" + @user.email
        #@user.save
        
        #### OLD DESTROY CODE
        @user.destroy

        ### Destroy any associated Goals (will remove from teams, checkpoints and cheers should delete as a result)
        @goals = Goal.find(:all, :conditions => "user_id = '#{params[:id]}'")
        for goal in @goals

          ### Destroy any associated Checkpoints
          checkpoints = Checkpoint.find(:all, :conditions => "goal_id = '#{goal.id}'")
          for checkpoint in checkpoints
            checkpoint.destroy
          end

          ### Destroy any associated Cheers
          cheers = Cheer.find(:all, :conditions => "goal_id = '#{goal.id}'")
          for cheer in cheers
            cheer.destroy
          end

          goal.quit_a_team
          goal.destroy
        end
    end

  
    if current_user_is_admin
      redirect_to(users_url)
    else
      ### Log out
      if current_user_session
        current_user_session.destroy
      end
      redirect_to("/?account_removed=1")
    end
  
    #respond_to do |format|
    #  format.html { redirect_to(users_url) }
    #  format.xml  { head :ok }
    #end
  end
end
