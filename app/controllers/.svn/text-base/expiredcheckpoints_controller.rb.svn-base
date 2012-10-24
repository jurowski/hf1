class ExpiredcheckpointsController < ApplicationController

  before_filter :require_admin_user
  
  # GET /expiredcheckpoints
  # GET /expiredcheckpoints.xml
  def index
    @expiredcheckpoints = Expiredcheckpoint.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @expiredcheckpoints }
    end
  end

  # GET /expiredcheckpoints/1
  # GET /expiredcheckpoints/1.xml
  def show
    @expiredcheckpoint = Expiredcheckpoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @expiredcheckpoint }
    end
  end

  # GET /expiredcheckpoints/new
  # GET /expiredcheckpoints/new.xml
  def new
    @expiredcheckpoint = Expiredcheckpoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @expiredcheckpoint }
    end
  end

  # GET /expiredcheckpoints/1/edit
  def edit
    @expiredcheckpoint = Expiredcheckpoint.find(params[:id])
  end

  # POST /expiredcheckpoints
  # POST /expiredcheckpoints.xml
  def create
    @expiredcheckpoint = Expiredcheckpoint.new(params[:expiredcheckpoint])

    respond_to do |format|
      if @expiredcheckpoint.save
        flash[:notice] = 'Expiredcheckpoint was successfully created.'
        format.html { redirect_to(@expiredcheckpoint) }
        format.xml  { render :xml => @expiredcheckpoint, :status => :created, :location => @expiredcheckpoint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @expiredcheckpoint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /expiredcheckpoints/1
  # PUT /expiredcheckpoints/1.xml
  def update
    @expiredcheckpoint = Expiredcheckpoint.find(params[:id])

    respond_to do |format|
      if @expiredcheckpoint.update_attributes(params[:expiredcheckpoint])
        flash[:notice] = 'Expiredcheckpoint was successfully updated.'
        format.html { redirect_to(@expiredcheckpoint) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @expiredcheckpoint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /expiredcheckpoints/1
  # DELETE /expiredcheckpoints/1.xml
  def destroy
    @expiredcheckpoint = Expiredcheckpoint.find(params[:id])
    @expiredcheckpoint.destroy

    respond_to do |format|
      format.html { redirect_to(expiredcheckpoints_url) }
      format.xml  { head :ok }
    end
  end
end
