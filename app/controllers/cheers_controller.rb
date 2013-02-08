class CheersController < ApplicationController
  layout "application"
  
  require 'date'
  require 'logger'
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
        @cheers = Cheer.find(:all, :conditions => "email = '#{current_user.email}'")

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

      end

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @cheers }
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
