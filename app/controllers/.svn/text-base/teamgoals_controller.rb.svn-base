class TeamgoalsController < ApplicationController

  before_filter :require_admin_user

  # GET /teamgoals
  # GET /teamgoals.xml
  def index
    @teamgoals = Teamgoal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teamgoals }
    end
  end

  # GET /teamgoals/1
  # GET /teamgoals/1.xml
  def show
    @teamgoal = Teamgoal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @teamgoal }
    end
  end

  # GET /teamgoals/new
  # GET /teamgoals/new.xml
  def new
    @teamgoal = Teamgoal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @teamgoal }
    end
  end

  # GET /teamgoals/1/edit
  def edit
    @teamgoal = Teamgoal.find(params[:id])
  end

  # POST /teamgoals
  # POST /teamgoals.xml
  def create
    @teamgoal = Teamgoal.new(params[:teamgoal])

    respond_to do |format|
      if @teamgoal.save
        flash[:notice] = 'Teamgoal was successfully created.'
        format.html { redirect_to(@teamgoal) }
        format.xml  { render :xml => @teamgoal, :status => :created, :location => @teamgoal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @teamgoal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teamgoals/1
  # PUT /teamgoals/1.xml
  def update
    @teamgoal = Teamgoal.find(params[:id])

    respond_to do |format|
      if @teamgoal.update_attributes(params[:teamgoal])
        flash[:notice] = 'Teamgoal was successfully updated.'
        format.html { redirect_to(@teamgoal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @teamgoal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teamgoals/1
  # DELETE /teamgoals/1.xml
  def destroy
    @teamgoal = Teamgoal.find(params[:id])
    @teamgoal.destroy

    respond_to do |format|
      format.html { redirect_to(teamgoals_url) }
      format.xml  { head :ok }
    end
  end
end
