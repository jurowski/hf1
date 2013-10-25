class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  layout "application"
  def new
    @user_session = UserSession.new
  end
  
  def create
    session[:single_login] = nil

    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      
      ### current_user will be nil here so this will not work
      #current_user.last_activity_date = current_user.dtoday
      #current_user.save

      if current_user_is_admin
        redirect_back_or_default account_url
      else
        
        if params[:after_login_cn]
            vars = ""
            if params[:after_login_param_1_name]
              vars = "?" + params[:after_login_param_1_name] + "=" + params[:after_login_param_1_val]
                ### Example:
                ### Send Direct Message 
                ### ?after_login_cn=tomessages&after_login_ca=new&after_login_param_1_name=to_id&&after_login_param_1_val=<%= team_goal.user.id %>
            end

            if params[:after_login_param_2_name]
              vars = vars + "&" + params[:after_login_param_2_name] + "=" + params[:after_login_param_2_val]
            end


            if params[:after_login_id]
                vars = "/" + params[:after_login_id]                
                ### Ex: update missing checkpoints: <a href="/user_session/new?skip_intro=1&after_login_cn=goals&after_login_ca=single&after_login_id=<%= @checkpoint.goal.id %>"><strong><font color=red>Update Missing Checkpoint(s)</font></a></strong>
            end
            
            if params[:after_login_ca]
                redirect_to("/" + params[:after_login_cn] + "/" + params[:after_login_ca] + vars)
            else
                redirect_to("/" + params[:after_login_cn] + vars)
            end
        else
          if !params[:quick_setup]
            redirect_to(goals_url)
          end
        end

        
      end
      session[:bad_password] = false      
    else
      session[:bad_password] = true
      render :action => :new
    end
  end
  
  def destroy
    session[:single_login] = nil
    session[:fake_login] = nil
    @current_user = nil

    current_user_session.destroy if current_user_session

    session[:dynamic_latest_public_checkins_max] = nil


    ### UNSET FB ITEMS ####
    session[:fb_id] = nil
    session[:fb_email] = nil
    session[:fb_username] = nil
    session[:fb_first_name] = nil
    session[:fb_last_name] = nil
    session[:fb_gender] = nil
    session[:fb_timezone] = nil

    
    flash[:notice] = "Logout successful!"
    redirect_to("/")
    #redirect_back_or_default new_user_session_url
  end
end
