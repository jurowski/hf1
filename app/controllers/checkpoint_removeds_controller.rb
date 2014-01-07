class CheckpointRemovedsController < ApplicationController

  before_filter :require_admin_user
  layout "application"
  
  # GET /checkpoint_removeds
  # GET /checkpoint_removeds.xml
  def index
    @checkpoint_removeds = CheckpointRemoved.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @checkpoint_removeds }
    end
  end

  # GET /checkpoint_removeds/1
  # GET /checkpoint_removeds/1.xml
  def show
    @checkpoint_removed = CheckpointRemoved.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @checkpoint_removed }
    end
  end

  # GET /checkpoint_removeds/new
  # GET /checkpoint_removeds/new.xml
  def new
    @checkpoint_removed = CheckpointRemoved.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @checkpoint_removed }
    end
  end

  # GET /checkpoint_removeds/1/edit
  def edit
    @checkpoint_removed = CheckpointRemoved.find(params[:id])
  end

  # POST /checkpoint_removeds
  # POST /checkpoint_removeds.xml
  def create
    @checkpoint_removed = CheckpointRemoved.new(params[:checkpoint_removed])

    respond_to do |format|
      if @checkpoint_removed.save
        flash[:notice] = 'CheckpointRemoved was successfully created.'
        format.html { redirect_to(@checkpoint_removed) }
        format.xml  { render :xml => @checkpoint_removed, :status => :created, :location => @checkpoint_removed }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @checkpoint_removed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /checkpoint_removeds/1
  # PUT /checkpoint_removeds/1.xml
  def update
    @checkpoint_removed = CheckpointRemoved.find(params[:id])

    respond_to do |format|
      if @checkpoint_removed.update_attributes(params[:checkpoint_removed])
        flash[:notice] = 'CheckpointRemoved was successfully updated.'
        format.html { redirect_to(@checkpoint_removed) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @checkpoint_removed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /checkpoint_removeds/1
  # DELETE /checkpoint_removeds/1.xml
  def destroy
    @checkpoint_removed = CheckpointRemoved.find(params[:id])
    @checkpoint_removed.destroy

    respond_to do |format|
      format.html { redirect_to(checkpoint_removeds_url) }
      format.xml  { head :ok }
    end
  end
end
