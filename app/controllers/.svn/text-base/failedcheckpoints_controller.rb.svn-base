class FailedcheckpointsController < ApplicationController


  before_filter :require_admin_user
  

  # GET /failedcheckpoints
  # GET /failedcheckpoints.xml
  def index
    @failedcheckpoints = Failedcheckpoint.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @failedcheckpoints }
    end
  end

  # GET /failedcheckpoints/1
  # GET /failedcheckpoints/1.xml
  def show
    @failedcheckpoint = Failedcheckpoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @failedcheckpoint }
    end
  end

  # GET /failedcheckpoints/new
  # GET /failedcheckpoints/new.xml
  def new
    @failedcheckpoint = Failedcheckpoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @failedcheckpoint }
    end
  end

  # GET /failedcheckpoints/1/edit
  def edit
    @failedcheckpoint = Failedcheckpoint.find(params[:id])
  end

  # POST /failedcheckpoints
  # POST /failedcheckpoints.xml
  def create
    @failedcheckpoint = Failedcheckpoint.new(params[:failedcheckpoint])

    respond_to do |format|
      if @failedcheckpoint.save
        flash[:notice] = 'Failedcheckpoint was successfully created.'
        format.html { redirect_to(@failedcheckpoint) }
        format.xml  { render :xml => @failedcheckpoint, :status => :created, :location => @failedcheckpoint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @failedcheckpoint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /failedcheckpoints/1
  # PUT /failedcheckpoints/1.xml
  def update
    @failedcheckpoint = Failedcheckpoint.find(params[:id])

    respond_to do |format|
      if @failedcheckpoint.update_attributes(params[:failedcheckpoint])
        flash[:notice] = 'Failedcheckpoint was successfully updated.'
        format.html { redirect_to(@failedcheckpoint) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @failedcheckpoint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /failedcheckpoints/1
  # DELETE /failedcheckpoints/1.xml
  def destroy
    @failedcheckpoint = Failedcheckpoint.find(params[:id])
    @failedcheckpoint.destroy

    respond_to do |format|
      format.html { redirect_to(failedcheckpoints_url) }
      format.xml  { head :ok }
    end
  end
end
