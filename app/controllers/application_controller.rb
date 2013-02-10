# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.


class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  ### Any private variables that you create must be listed here to be accessed elsewhere (unless they're in the helper file, in which they're public):
  helper_method :current_user_session, :current_user, :current_user_is_admin, :server_root_url, :fully_logged_in

  filter_parameter_logging :password, :password_confirmation

  before_filter :save_referer

  ### Force SSL ... keep in mind that in Google Chrome, people may get "insecure content" messages
  ### if you enable this without ensuring that any external javascript aren't also called w/ https
  # ...also will show this for the sharing buttons and the uservoice...perhaps disable...
  #before_filter :redirect_to_ssl



  private

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

    def current_user
      return @current_user if defined?(@current_user)      
     
      if params[:single_login] and params[:email]
        session[:email] = params[:email]
        session[:single_login] = params[:single_login]
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
        
        ### EXAMPLE URL: /goals?update_checkpoint_status=no&date=2012-01-28&e0=106&f0=97&u=15706&goal_id=25855
        if params[:goal_id] and params[:u] and params[:e0] and params[:f0]
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
              if session[:email] and session[:single_login] and (!request.url.to_s.include? "/user" and !request.url.to_s.include? "/account")
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
        redirect_to "/user_session/new?skip_intro=1"
        return false
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


  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
