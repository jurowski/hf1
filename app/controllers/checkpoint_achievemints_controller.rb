class CheckpointAchievemintsController < ApplicationController
  # GET /checkpoint_achievemints
  # GET /checkpoint_achievemints.xml
  def index
    @checkpoint_achievemints = CheckpointAchievemint.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @checkpoint_achievemints }
    end
  end

  # GET /checkpoint_achievemints/1
  # GET /checkpoint_achievemints/1.xml
  def show
    @checkpoint_achievemint = CheckpointAchievemint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @checkpoint_achievemint }
    end
  end

  # GET /checkpoint_achievemints/new
  # GET /checkpoint_achievemints/new.xml
  def new
    @checkpoint_achievemint = CheckpointAchievemint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @checkpoint_achievemint }
    end
  end

  # GET /checkpoint_achievemints/1/edit
  def edit
    @checkpoint_achievemint = CheckpointAchievemint.find(params[:id])
  end

  # POST /checkpoint_achievemints
  # POST /checkpoint_achievemints.xml
  def create
    @checkpoint_achievemint = CheckpointAchievemint.new(params[:checkpoint_achievemint])

    respond_to do |format|
      if @checkpoint_achievemint.save
        flash[:notice] = 'CheckpointAchievemint was successfully created.'
        format.html { redirect_to(@checkpoint_achievemint) }
        format.xml  { render :xml => @checkpoint_achievemint, :status => :created, :location => @checkpoint_achievemint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @checkpoint_achievemint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /checkpoint_achievemints/1
  # PUT /checkpoint_achievemints/1.xml
  def update
    @checkpoint_achievemint = CheckpointAchievemint.find(params[:id])

    respond_to do |format|
      if @checkpoint_achievemint.update_attributes(params[:checkpoint_achievemint])
        flash[:notice] = 'CheckpointAchievemint was successfully updated.'
        format.html { redirect_to(@checkpoint_achievemint) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @checkpoint_achievemint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /checkpoint_achievemints/1
  # DELETE /checkpoint_achievemints/1.xml
  def destroy
    @checkpoint_achievemint = CheckpointAchievemint.find(params[:id])
    @checkpoint_achievemint.destroy

    respond_to do |format|
      format.html { redirect_to(checkpoint_achievemints_url) }
      format.xml  { head :ok }
    end
  end
end
