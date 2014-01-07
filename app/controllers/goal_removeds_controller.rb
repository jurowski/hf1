class GoalRemovedsController < ApplicationController

  before_filter :require_admin_user
  layout "application"
  # GET /goal_removeds
  # GET /goal_removeds.xml
  def index
    @goal_removeds = GoalRemoved.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @goal_removeds }
    end
  end

  # GET /goal_removeds/1
  # GET /goal_removeds/1.xml
  def show
    @goal_removed = GoalRemoved.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @goal_removed }
    end
  end

  # GET /goal_removeds/new
  # GET /goal_removeds/new.xml
  def new
    @goal_removed = GoalRemoved.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @goal_removed }
    end
  end

  # GET /goal_removeds/1/edit
  def edit
    @goal_removed = GoalRemoved.find(params[:id])
  end

  # POST /goal_removeds
  # POST /goal_removeds.xml
  def create
    @goal_removed = GoalRemoved.new(params[:goal_removed])

    respond_to do |format|
      if @goal_removed.save
        flash[:notice] = 'GoalRemoved was successfully created.'
        format.html { redirect_to(@goal_removed) }
        format.xml  { render :xml => @goal_removed, :status => :created, :location => @goal_removed }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @goal_removed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /goal_removeds/1
  # PUT /goal_removeds/1.xml
  def update
    @goal_removed = GoalRemoved.find(params[:id])

    respond_to do |format|
      if @goal_removed.update_attributes(params[:goal_removed])
        flash[:notice] = 'GoalRemoved was successfully updated.'
        format.html { redirect_to(@goal_removed) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @goal_removed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /goal_removeds/1
  # DELETE /goal_removeds/1.xml
  def destroy
    @goal_removed = GoalRemoved.find(params[:id])
    @goal_removed.destroy

    respond_to do |format|
      format.html { redirect_to(goal_removeds_url) }
      format.xml  { head :ok }
    end
  end
end
