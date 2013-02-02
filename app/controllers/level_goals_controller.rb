class LevelGoalsController < ApplicationController
  # GET /level_goals
  # GET /level_goals.xml
  def index
    @level_goals = LevelGoal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @level_goals }
    end
  end

  # GET /level_goals/1
  # GET /level_goals/1.xml
  def show
    @level_goal = LevelGoal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @level_goal }
    end
  end

  # GET /level_goals/new
  # GET /level_goals/new.xml
  def new
    @level_goal = LevelGoal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @level_goal }
    end
  end

  # GET /level_goals/1/edit
  def edit
    @level_goal = LevelGoal.find(params[:id])
  end

  # POST /level_goals
  # POST /level_goals.xml
  def create
    @level_goal = LevelGoal.new(params[:level_goal])

    respond_to do |format|
      if @level_goal.save
        flash[:notice] = 'LevelGoal was successfully created.'
        format.html { redirect_to(@level_goal) }
        format.xml  { render :xml => @level_goal, :status => :created, :location => @level_goal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @level_goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /level_goals/1
  # PUT /level_goals/1.xml
  def update
    @level_goal = LevelGoal.find(params[:id])

    respond_to do |format|
      if @level_goal.update_attributes(params[:level_goal])
        flash[:notice] = 'LevelGoal was successfully updated.'
        format.html { redirect_to(@level_goal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @level_goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /level_goals/1
  # DELETE /level_goals/1.xml
  def destroy
    @level_goal = LevelGoal.find(params[:id])
    @level_goal.destroy

    respond_to do |format|
      format.html { redirect_to(level_goals_url) }
      format.xml  { head :ok }
    end
  end
end
