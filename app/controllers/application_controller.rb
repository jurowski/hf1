# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.


class ApplicationController < ActionController::Base

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  ### using this to read output for google authentication when verifying a token
  require 'open-uri'


  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  ### Any private variables that you create must be listed here to be accessed elsewhere (unless they're in the helper file, in which they're public):
  helper_method :current_user_session, :current_user, :current_user_is_admin, :server_root_url, :fully_logged_in, :mobile_device?, :arr_random_slacker_goals, :secure_page?, :test_layout?

  filter_parameter_logging :password, :password_confirmation

  before_filter :save_referer

  ### Force SSL ... keep in mind that in Google Chrome, people may get "insecure content" messages
  ### if you enable this without ensuring that any external javascript aren't also called w/ https
  # ...also will show this for the sharing buttons and the uservoice...perhaps disable...
  #before_filter :redirect_to_ssl
  before_filter :redirect_to_ssl_login



  private

    def secure_page?
      if request.url.include? 'https://'
        return true
      else
        return false
      end
    end

    def test_layout?
      if params[:test_layout] and params[:test_layout] == "1"
        session[:test_layout] = true
      end
      if params[:test_layout] and params[:test_layout] == "0"
        session[:test_layout] = nil
      end
      if session[:test_layout]
        return true
      else
        return false
      end

    end

    def mobile_device?
      if params[:mobile_screen_test] == "1"
        session[:mobile_screen_test] = true
      end
      if params[:mobile_screen_test] == "0"
        session[:mobile_screen_test] = false
      end
      if session[:mobile_screen_test]
        return true
      end


      if session[:mobile_param]
        session[:mobile_param] == "1"
      else
        #request.user_agent =~ /Mobile|android|webos|iphone|ipad|ipod|blackberry/
        request.user_agent =~ /Mobile|android|webos|iphone|ipod|blackberry/
      end

      #return true
    end

    def save_referer
        if !session[:referer]
          session[:referer] = request.env["HTTP_REFERER"] || 'none'
        end
    end

    def redirect_to_ssl
      #if request.url.include? 'http://' and (local_request? == false)
      ### don't want to force the sponsored sites to SSL cause they'll say "untrusted connection" due to cert name
      if request.url.include? 'http://habitforge.com' and (local_request? == false)
          old_url = request.url
          new_url = request.url.sub("http://", "https://")
        redirect_to new_url
      end
    end 

    def redirect_to_ssl_login

      stay_here = false

      if local_request? == false
        if (request.url.include? 'https://')
          ### landed on https

          if (request.url.include? '/user_session' or request.url.include? '/account')          
            ### yes we should stay on https
            stay_here = true
          else
            ### hey, it's silly to stay on https since we'd be blocking insecure content
            stay_here = false
            old_url = request.url
            new_url = request.url.sub("https://", "http://")
            redirect_to new_url            
          end

        else
          ### landed on http

          if (request.url.include? '/user_session/new' or request.url.include? '/account')          
            ### hey, we should be on https
            stay_here = false
            old_url = request.url
            new_url = request.url.sub("http://", "https://")
            redirect_to new_url            
          else
            ### yes, we should stay on http
            stay_here = true
          end

        end
      end

    end 

    def server_root_url
      if `uname -n`.strip == 'adv.adventurino.com'
        #### HABITFORGE SETTINGS ON VPS
        @server_root_url = "http://habitforge.com"
      elsif `uname -n`.strip == 'gns499aa.joyent.us'
        #### DEV SETTINGS ON HABITFORGE VPS
        @server_root_url = "http://dev.habitforge.com"
      else
        #### SETTINGS FOR DEV LAPTOP
        @server_root_url = "http://localhost:3000"
      end
      
      
      
      ###### SKINNED SITES ###########
      if request.domain.include? 'mylearninghabit'
        @server_root_url = "http://www.mylearninghabit.com"
      end
      if request.domain.include? 'eathealthy'
        @server_root_url = "http://eathealthy.habitforge.com"
      end
      if request.domain.include? 'reengagefocus'
        @server_root_url = "http://reengagefocus.com"
      end
      if request.domain.include? 'forittobe'
        @server_root_url = "http://forittobe.com"
      end
      if request.domain.include? 'marriagereminders'
        @server_root_url = "http://marriagereminders.com"
      end
            
      return @server_root_url
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)


      ### YOU CAN ONLY ACTUALLY LOG SOMEONE IN IF YOU KNOW THEIR PW
      ### DO NOT TRY TO LOG IN W/ A DUMMY ACCOUNT AND THEN RETURN A DIFF. CURRENT USER
      ### ...IT MAY WORK w/ ADMIN BUT WILL GET MESSY WITH MULTIPLE PEOPLE DOING THIS

      #########################################################################
      ##############  SGJ auto-log in (widget users) ##########################
      ###if a URL contains a param called :diu and if there is a user.id = :diu
      ###and if password_temp contains something
      ###and if a URL params contain param of :ptm = "43" + the :password_temp value + "9cth" 
      ###then auto-log them in
      if params[:diu]
        user = User.find(params[:diu].to_i)
        if user
          if user.password_temp != nil and user.password_temp != ""
            if params[:ptm] and params[:ptm] == "43" + user.password_temp + "9cth"
              ### auto-log them in
              @user_session = UserSession.new
              @user_session.password = user.password_temp
              @user_session.email = user.email
              @user_session.save

            end
          end
        end
      end
      ############################################################
      ############################################################



      @current_user_session = UserSession.find

    end
    
    
    def current_user_is_admin
        if current_user != nil
            if current_user.is_admin == 1 
              session[:current_user_is_admin] = true
              return true
            else
              return false
            end
        else
            return false
        end
    end
    
    def fully_logged_in
        if !current_user_session
            return false
        else
            return true
        end
    end




    # def free_trial

    #   #return true

    #   ### slow, dynamic way ... make sure you read from one db field in the future
    #   if !request.url.include? "/goals/new" and current_user and (current_user.date_of_signup and current_user.date_of_signup >= current_user.dtoday - 14) and !current_user.is_habitforge_supporting_member
    #     return true
    #   else
    #     return false
    #   end
    # end

    def current_user
      return @current_user if defined?(@current_user)      

      ###### TEST REMOVE ME AFTER TEST
      if params[:google_email]
        session[:google_email] = params[:google_email]
      end     

      if session[:fb_username]
        user = User.find(:first, :conditions => "fb_username = '#{session[:fb_username]}'")
        if user
          @current_user = user
          return @current_user
        end
      end

      if session[:google_email]
        user = User.find(:first, :conditions => "google_email = '#{session[:google_email]}'")
        if user
          session[:email] = user.email
          session[:single_login] = true

          @current_user = user
          return @current_user
        end

        user = User.find(:first, :conditions => "email = '#{session[:google_email]}'")
        if user
          session[:email] = user.email
          session[:single_login] = true

          @current_user = user
          return @current_user
        end

      end



      if params[:single_login] and params[:email]
        session[:email] = params[:email]
        session[:single_login] = params[:single_login]
      end


      if session[:email] and session[:single_login]
        user = User.find(:first, :conditions => "email = '#{session[:email]}'")
        if user
          @current_user = user
          return @current_user
        end
      end


     if session[:current_user_is_admin] == true and (params[:impersonate] or session[:impersonate])
        logger.debug("sgj:attempting impersonation")
       ######### ADMIN IMPERSONATE A USER ###################
       if params[:impersonate]
        session[:impersonate] = params[:impersonate]
       end       
       @current_user = User.find(session[:impersonate])
     else
        logger.debug("sgj:no current user, check for fake/single logins")
        ### let user fake a login for one page, if they have enough correct info for coming in via email URL
        ### since there is no "current_user_session && current_user_session.record", it won't stay across requests



        ### if someone is confirming their account
        if params[:confirmed_address_token] and params[:user_id]
          logger.info("sgj:attempting account confirmation for user_id:" + params[:user_id])
          user = User.find(params[:user_id].to_i)
          if user
            if user.confirmed_address_token == params[:confirmed_address_token]

              @current_user = user

              ### hey, let's LET them do the persistent
              ### "session[:email] and session[:single_login]" here

              session[:email] = user.email
              session[:single_login] = true

            end

          end
        end


        ### autoupdatemultiple
        if params[:g] and params[:u]
            logger.debug("sgj:attempting single login w/ goal/user info")
            goal = Goal.find(params[:g].to_i)
            if goal
                if goal.user
                    if goal.user.id == params[:u].to_i
                        @current_user = goal.user

                            ### hey, let's LET them do the persistent
                            ### "session[:email] and session[:single_login]" here

                        session[:email] = goal.user.email
                        session[:single_login] = true
                    end
                end
            end
        end    


        if params[:goal_id] and params[:u] and params[:e0] and params[:f0]


            ### let them in if they are replying to a "tomessage"
            ### ex: http://habitforge.com/tomessages/new?to_id=88281&replying_to_message_id=5587&u=89491&e0=99&f0=67&goal_id=0
            user = User.find(params[:u].to_i)
            if user
              if user.id == params[:u].to_i and user.email[0] == params[:e0].to_i and user.first_name[0] == params[:f0].to_i
                  session[:fake_login] = params[:u] + params[:e0] + params[:f0] 
                  @current_user = user

                      ### hey, let's LET them do the persistent
                      ### "session[:email] and session[:single_login]" here

                  session[:email] = user.email
                  session[:single_login] = true
              end
            else

              ### EXAMPLE URL: /goals?update_checkpoint_status=no&date=2012-01-28&e0=106&f0=97&u=15706&goal_id=25855
              logger.debug("sgj:attempting single login w/ goal/user/email id info")
              goal = Goal.find(params[:goal_id].to_i)
              if goal
                  if goal.user
                      if goal.user.id == params[:u].to_i and goal.user.email[0] == params[:e0].to_i and goal.user.first_name[0] == params[:f0].to_i
                          session[:fake_login] = params[:u] + params[:e0] + params[:f0] 
                          @current_user = goal.user

                              ### hey, let's LET them do the persistent
                              ### "session[:email] and session[:single_login]" here

                          session[:email] = goal.user.email
                          session[:single_login] = true
                      end
                  end
              end

            end


        else
          logger.debug("sgj:attempting single login via goal_id or email param")
            if !fully_logged_in and (params[:goal_id] or (session[:email] and session[:single_login]))
              if params[:goal_id]
                goal = Goal.find(params[:goal_id].to_i)
                if goal
                    if goal.user
                        fake_login = goal.user.id.to_s + goal.user.email[0].to_s + goal.user.first_name[0].to_s
                        if session[:fake_login] == fake_login
                            @current_user = goal.user
                            ### hey, let's not let them do the persistent
                            ### "session[:email] and session[:single_login]" here, b/c it is just too ease
                            ### for someone to pop in just any goal id and then become that person
                        end 
                    end
                end
              end

              ##############################################################
              ###### Find user, grant temp login via email in param ####
              ### this is the case often if we are coming from an
              ### InfusionSoft email link where we only have their email address

              #### DANGER ... restricting to all but "user" below ...
              if session[:email] and session[:single_login] and ((!request.url.to_s.include? "/user") and (!request.url.to_s.include? "/account"))
                begin
                  user = User.find(:first, :conditions => "email = '#{session[:email]}'")
                  if user
                     @current_user = user
                  end
                rescue
                  logger.error("sgj:error finding user via params email")
                end
              end
              ###### END Find user, grant temp login via email in param ####
              ##############################################################

            else
                ######### NORMAL USER
                @current_user = current_user_session && current_user_session.record            
            end
        end
     end
    end

    def require_admin_user
      unless current_user_is_admin
        store_location
        flash[:notice] = "You must be logged in as an admin to access this page"
        #redirect_to new_user_session_url
        redirect_to "/goals"
        return false
      end
    end

    def require_user_unless_newly_paid_or_browsing
      # Newly Paid User
      # (When someone comes back from infusionsoft having just paid for a premium account)
      # http://habitforge.com/goals?optimize_my_first_goal=1&ga_goal=1&email=newuser@test.com&single_login=1
      if params[:optimize_my_first_goal] and params[:ga_goal] and params[:email] and params[:single_login]
        if current_user
          return true
        else
          #redirect to the URL that free users use for quick signup
          redirect_to "/quicksignup_v2?email=#{params[:email]}&form_submitted=1&ga_goal=1"
          return false
        end
      else

        ### if wanting to view a success program
        if params[:program_id] and params[:programs] and params[:browse_recommended_habits]

          return true

        else

          unless current_user
            store_location
            flash[:notice] = "You must be logged in to access this page"
            #redirect_to new_user_session_url
            redirect_to "/user_session/new?skip_intro=1"
            return false
          end


        end

      end
    end


    def require_user_can_make_templates
      unless (current_user and current_user.can_make_templates)
          flash[:notice] = "You do not have rights to access that page."
          redirect_to "/"
          return false
      end
    end

    def require_program_scope
      if params[:id]
        program = Program.find(params[:id].to_i)
        unless (current_user and program and (current_user.is_admin or (current_user.id == program.managed_by_user_id)))
          flash[:notice] = "You do not have rights to access that page."
          redirect_to "/"
          return false          
        end
      end
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        #redirect_to new_user_session_url
        redirect_to "/user_session/new?skip_intro=1"
        return false
      end
    end
 
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end



    def arr_random_slacker_goals(max_counter)


      logger.debug("sgj:application_helper.rb:arr_random_slacker_goal:1")
      arr_chosen_goals = Array.new()

      keep_looking = true
      counter = 0


      #### DEBUG
      slacker_goals = Goal.find(:all, :conditions => "publish = '1' and status <> 'hold' and laststatusdate > '#{get_dnow - 30}'")

      #### LIVE
      #slacker_goals = Goal.find(:all, :conditions => "publish = '1' and status <> 'hold' and laststatusdate > '#{get_dnow - 30}' and laststatusdate < '#{get_dnow - 7}'")

      logger.debug("sgj:application_helper.rb:arr_random_slacker_goal:2:just tried to find slacker_goals .. size is " + slacker_goals.size.to_s)
      if slacker_goals.size > 0

        slacker_goals.each do |slacker_goal|

            logger.debug("sgj:application_helper.rb:arr_random_slacker_goal:3:looking at slacker_goal.title of " + slacker_goal.title)
            break if !keep_looking
            random_index = rand(slacker_goals.size) #between 0 and (size - 1)
            slacker_goal = slacker_goals[random_index]

            logger.debug("sgj:application_helper.rb:arr_random_slacker_goal:3.1:about to see if free user")

            ### do this for Free users only (to keep them involved)
            #if slacker_goal and slacker_goal.user and !slacker_goal.user.is_habitforge_supporting_member

            ### do this for all users
            if slacker_goal and slacker_goal.user
              logger.debug("sgj:application_helper.rb:arr_random_slacker_goal:4:about to check if user has name")
              if slacker_goal.user.first_name != "unknown" and !arr_chosen_goals.include? slacker_goal
                arr_chosen_goals << slacker_goal
                counter = counter + 1
                if counter == max_counter
                  keep_looking = false
                end

              end ### end if slacker goal user has a real name (vs. unknown)
           end ### end if there's still a slacker goal
        end ### end each slacker goal
      end ### end all slacker goals

      return arr_chosen_goals

    end


  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
