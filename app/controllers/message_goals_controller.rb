class MessageGoalsController < ApplicationController
  # GET /message_goals
  # GET /message_goals.xml
  def index
    @message_goals = MessageGoal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_goals }
    end
  end

  # GET /message_goals/1
  # GET /message_goals/1.xml
  def show
    @message_goal = MessageGoal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_goal }
    end
  end

  # GET /message_goals/new
  # GET /message_goals/new.xml
  def new
    @message_goal = MessageGoal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_goal }
    end
  end

  # GET /message_goals/1/edit
  def edit
    @message_goal = MessageGoal.find(params[:id])
  end

  # POST /message_goals
  # POST /message_goals.xml
  def create
    @message_goal = MessageGoal.new(params[:message_goal])

    respond_to do |format|
      if @message_goal.save
        flash[:notice] = 'MessageGoal was successfully created.'
        format.html { redirect_to(@message_goal) }
        format.xml  { render :xml => @message_goal, :status => :created, :location => @message_goal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /message_goals/1
  # PUT /message_goals/1.xml
  def update
    @message_goal = MessageGoal.find(params[:id])

    respond_to do |format|
      if @message_goal.update_attributes(params[:message_goal])
        flash[:notice] = 'MessageGoal was successfully updated.'
        format.html { redirect_to(@message_goal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /message_goals/1
  # DELETE /message_goals/1.xml
  def destroy
    @message_goal = MessageGoal.find(params[:id])
    @message_goal.destroy

    respond_to do |format|
      format.html { redirect_to(message_goals_url) }
      format.xml  { head :ok }
    end
  end
end
