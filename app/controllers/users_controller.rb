require "mail"
class UsersController < ApplicationController
  layout "application"

  # GET /users
  # GET /users.xml


  ### Do you want to be able to create new users when someone is logged in?
  #before_filter :require_no_user, :only => [:new, :create]
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
                user.combine_daily_emails = 0
                user.hide_donation_plea = 1
                user.unlimited_goals = 1
                user.kill_ads_until = dnow + days
                user.sent_expire_warning_on = '1900-01-01'
            
                if user.payments == nil
                    user.payments = 0.0
                end
                user.payments = user.payments + 10.00
                user.last_donation_date = dnow
                if user.save
                    logger.info 'HF SUCCESS upgrading user account for ' + user.email
                else 
                    logger.info 'HF ERROR upgrading user account for ' + user.email
                end
                ### Send email to user and CC support w/ thank you and upgrade info
                logger.info 'HF ATTEMPTING TO Send email to user and CC support w/ thank you and upgrade info'
                Notifier.deliver_user_upgrade_notification(user) # sends the email
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

    if @email_valid
      ### validate email
      user = User.find(:first, :conditions => "email = '#{params[:email]}'"
)
      if user != nil
        @email_duplicate = true
      end
    end ### end if email_submitted

    if @email_duplicate
      ### ask the user to enter a new email address or log in w/ the existing one
    else
      user = User.new
      user.first_name = "unknown"
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

      if params[:affiliate_name] and params[:affiliate_name] != ""
        affiliate = Affiliate.find(:first, :conditions => "affiliate_name = '#{params[:affiliate_name]}'")
        if affiliate
          user.affiliate = affiliate
        end
      end

      ### Setting this to something other than 0 so that this person
      ### is included in the next morning's cron job to send emails
      ### this will get reset to the right number once each day via cron
      ### but set it now in case user is being created after that job runs
      user.update_number_active_goals = 1

      if user.save 

        stats_increment_new_user

        ### do something like the below once we know what their goal is
        #@user = user
        #Notifier.deliver_widget_user_creation(@user) # sends the email
        session[:sfm_virgin] = true ### they are setting up their first goal ... allows you to hide or show certain things
        session[:sfm_virgin_need_to_confirm_timezone] = true
        session[:sfm_virgin_need_to_email_temp_password] = true
        @account_created = true

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

                session[:infusionsoft_contact_id] = 0
		new_contact_id = Infusionsoft.contact_add({:FirstName => user.first_name, :LastName => user.last_name, :Email => user.email})
		Infusionsoft.email_optin(user.email, 'HabitForge signup')
		Infusionsoft.contact_add_to_group(new_contact_id, 400)
		session[:infusionsoft_contact_id] = new_contact_id
	        ####          END INFUSIONSOFT CONTACT           ####
	        #####################################################
	        #####################################################
        rescue
	  logger.error("sgj:error creating infusionsoft contact")
        end

        ### route them to goal creation page (which should reference session[:sfm] for quick goal-creation options)
        redirect_to("/goals/new")
      else
        ### Problem saving user: ask them to contact support
      end ### end if user.save

    end ### end if not duplicate email


  end

  # GET /users/new
  # GET /users/new.xml
  def new

    @user = User.new

    
    if session[:affiliate_name] != nil and session[:affiliate_name] != ""
      @affiliate = Affiliate.find(:first, :conditions => "affiliate_name = '#{session[:affiliate_name]}'")
      if @affiliate
          @user.affiliate = @affiliate
      end
    end

    #@user.yob = 1980
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.xml  { render :xml => @user }
    #end
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


    #### ALLOW FOR EMAIL ADDRESS CONFIRMATION
    random_confirm_token = rand(1000) + 1 #between 1 and 1000
    @user.confirmed_address_token = "xtynzsc" + random_confirm_token.to_s
    if @user.save
      flash[:notice] = "Account registered!"
     
      #### now that we have saved and have the user id, we can send the email 
      the_subject = "Confirm your HabitForge Subscription"
      begin
        Notifier.deliver_user_confirm(@user, the_subject) # sends the email
      rescue
        logger.error("sgj:email confirmation for user creation did not send")
      end
      

      ### FIELDS
      #stat recorddate:date recordhour:integer usercount:integer goalcount:integer goalactivecount:integer goalsnewcreated:integer usersnewcreated:integer checkpointemailssent:integer

      stats_increment_new_user
      
      #Notifier.deliver_signup_notification(@user) # sends the email
      
      if params[:account_type] and params[:account_type] == "supporting"
          #redirect_to("http://habitforge.myshopify.com/collections/frontpage/products/habitforge-supporting-membership-1-year?ref=#{@user.id.to_s}")
          redirect_to("https://www.securepublications.com/habit-1-year.php?ref=#{@user.id.to_s}&email=#{@user.email}")
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
    
    ### having periods in the first name kills the attempts to email that person, so remove periods
    @user.first_name = @user.first_name.gsub(".", "")
    
    if @user.update_attributes(params[:user])

      if session[:sfm_virgin_need_to_confirm_timezone]
        session[:sfm_virgin_need_to_confirm_timezone] = false
      end

      @user.password_temp = ""
      @user.save

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
        ### do not delete user account, just put "xxx_date" in front of email so we have a history
        #@user.email = "xxx_" + get_dnow.to_s + "_" + @user.email
        #@user.save
        
        #### OLD DESTROY CODE
        @user.destroy

        ### Destroy any associated Goals (will remove from teams, checkpoints and cheers should delete as a result)
        @goals = Goal.find(:all, :conditions => "user_id = '#{params[:id]}'")
        for goal in @goals
          goal.destroy
        end
    end

  
    if current_user_is_admin
      redirect_to(users_url)
    else
      ### Log out
      current_user_session.destroy
      redirect_to("/?account_removed=1")
    end
  
    #respond_to do |format|
    #  format.html { redirect_to(users_url) }
    #  format.xml  { head :ok }
    #end
  end
end
