class CronjobsController < ApplicationController
  # GET /cronjobs
  # GET /cronjobs.xml
  def index
    @cronjobs = Cronjob.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cronjobs }
    end
  end

  # GET /cronjobs/1
  # GET /cronjobs/1.xml
  def show
    @cronjob = Cronjob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cronjob }
    end
  end

  # GET /cronjobs/new
  # GET /cronjobs/new.xml
  def new
    @cronjob = Cronjob.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cronjob }
    end
  end

  # GET /cronjobs/1/edit
  def edit
    @cronjob = Cronjob.find(params[:id])
  end

  # POST /cronjobs
  # POST /cronjobs.xml
  def create
    @cronjob = Cronjob.new(params[:cronjob])

    respond_to do |format|
      if @cronjob.save
        flash[:notice] = 'Cronjob was successfully created.'
        format.html { redirect_to(@cronjob) }
        format.xml  { render :xml => @cronjob, :status => :created, :location => @cronjob }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cronjob.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cronjobs/1
  # PUT /cronjobs/1.xml
  def update
    @cronjob = Cronjob.find(params[:id])

    respond_to do |format|
      if @cronjob.update_attributes(params[:cronjob])
        flash[:notice] = 'Cronjob was successfully updated.'
        format.html { redirect_to(@cronjob) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cronjob.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cronjobs/1
  # DELETE /cronjobs/1.xml
  def destroy
    @cronjob = Cronjob.find(params[:id])
    @cronjob.destroy

    respond_to do |format|
      format.html { redirect_to(cronjobs_url) }
      format.xml  { head :ok }
    end
  end
end
