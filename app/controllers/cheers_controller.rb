class CheersController < ApplicationController
  layout "application"
  
  require 'date'
  require 'logger'

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  layout "application"


  #before_filter :require_user
  before_filter :require_user, :only => [:edit, :update, :index, :destroy]
  #before_filter :require_admin_user
  
  # GET /cheers
  # GET /cheers.xml
  def index
      if current_user_is_admin
        @cheers = Cheer.find(:all)
      else

        redirect_me = false
        
        if params[:start_following_goal_id] and params[:email] and current_user and current_user.email == params[:email]

          if params[:email] != "hbbyer@shaw.ca"
            new_cheer = Cheer.new()
            new_cheer.email = params[:email]
            new_cheer.goal_id = params[:start_following_goal_id].to_i
            new_cheer.save

            begin
              goal = Goal.find(params[:start_following_goal_id].to_i)
              Notifier.deliver_notify_user_new_follower(goal, current_user) # sends the email

              flash[:notice] = 'You are following a new goal!'
              if session[:show_winners_return_to_me] and session[:show_winners_return_to_me] != ""
                #redirect_to(session[:show_winners_return_to_me] + "&flash=message_sent#winners")
                redirect_me = true
              end
            rescue
              logger.error("sgj:cheers_controller:error emailing re: new follower")
            end
          end ### end if params[:email] != "hbbyer@shaw.ca"

        end

        if params[:stop_weekly_report]
          begin
            stop_cheer = Cheer.find(params[:stop_weekly_report].to_i)
            if stop_cheer
              stop_cheer.weekly_report = false
              stop_cheer.save
              flash[:notice] = 'Weekly report disabled.'
            end
          rescue
            logger.error("sgj:cheers_controller:error while trying to stop weekly report for cheer_id of " + params[:stop_weekly_report])
          end
        end


        if params[:start_weekly_report]
          begin
            start_cheer = Cheer.find(params[:start_weekly_report].to_i)
            if start_cheer
              start_cheer.weekly_report = true
              start_cheer.save
              flash[:notice] = 'Weekly report enabled.'
            end
          rescue
            logger.error("sgj:cheers_controller:error while trying to start weekly report for cheer_id of " + params[:start_weekly_report])
          end
        end

        @cheers = Cheer.find(:all, :conditions => "email = '#{current_user.email}'")
      end

      if redirect_me and session[:show_winners_return_to_me]
        redirect_to(session[:show_winners_return_to_me] + "&flash=new_follow#winners")
      else
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @cheers }
        end
      end

  end

  # GET /cheers/1
  # GET /cheers/1.xml
  def show
    @cheer = Cheer.find(params[:id])

    respond_to do |format|
    format.html # show.html.erb
    format.xml  { render :xml => @cheer }
    end
  end

  # GET /cheers/new
  # GET /cheers/new.xml
  def new
    @cheer = Cheer.new

    respond_to do |format|
    format.html # new.html.erb
    format.xml  { render :xml => @cheer }
    end
  end

  # GET /cheers/1/edit
  def edit
      @cheer = Cheer.find(params[:id])
  end

  # POST /cheers
  # POST /cheers.xml
  def create
    @cheer = Cheer.new(params[:cheer])

    respond_to do |format|
    if @cheer.save
      flash[:notice] = 'Cheer was successfully created.'
      format.html { redirect_to(@cheer) }
      format.xml  { render :xml => @cheer, :status => :created, :location => @cheer }
    else
      format.html { render :action => "new" }
      format.xml  { render :xml => @cheer.errors, :status => :unprocessable_entity }
    end
    end
  end

  # PUT /cheers/1
  # PUT /cheers/1.xml
  def update
    @cheer = Cheer.find(params[:id])

    respond_to do |format|
    if @cheer.update_attributes(params[:cheer])
      flash[:notice] = 'Cheer was successfully updated.'
      format.html { redirect_to(@cheer) }
      format.xml  { head :ok }
    else
      format.html { render :action => "edit" }
      format.xml  { render :xml => @cheer.errors, :status => :unprocessable_entity }
    end
    end
  end

  # DELETE /cheers/1
  # DELETE /cheers/1.xml
  def destroy
    @cheer = Cheer.find(params[:id])
    @cheer.destroy

    respond_to do |format|
    format.html { redirect_to(cheers_url) }
    format.xml  { head :ok }
    end
  end
end
