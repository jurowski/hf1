class CoachgoalsController < ApplicationController
  before_filter :require_admin_user
  

  
  # GET /coachgoals
  # GET /coachgoals.xml
  def index
    @coachgoals = Coachgoal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coachgoals }
    end
  end

  # GET /coachgoals/1
  # GET /coachgoals/1.xml
  def show
    @coachgoal = Coachgoal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @coachgoal }
    end
  end

  # GET /coachgoals/new
  # GET /coachgoals/new.xml
  def new
    @coachgoal = Coachgoal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coachgoal }
    end
  end

  # GET /coachgoals/1/edit
  def edit
    @coachgoal = Coachgoal.find(params[:id])
  end

  # POST /coachgoals
  # POST /coachgoals.xml
  def create
    @coachgoal = Coachgoal.new(params[:coachgoal])

    respond_to do |format|
      if @coachgoal.save
        flash[:notice] = 'Coachgoal was successfully created.'
        format.html { redirect_to(@coachgoal) }
        format.xml  { render :xml => @coachgoal, :status => :created, :location => @coachgoal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coachgoal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /coachgoals/1
  # PUT /coachgoals/1.xml
  def update
    @coachgoal = Coachgoal.find(params[:id])

    respond_to do |format|
      if @coachgoal.update_attributes(params[:coachgoal])
        flash[:notice] = 'Coachgoal was successfully updated.'
        format.html { redirect_to(@coachgoal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @coachgoal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /coachgoals/1
  # DELETE /coachgoals/1.xml
  def destroy
    @coachgoal = Coachgoal.find(params[:id])
    @coachgoal.destroy

    respond_to do |format|
      format.html { redirect_to(coachgoals_url) }
      format.xml  { head :ok }
    end
  end
end
