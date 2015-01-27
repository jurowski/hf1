class ImpactLeadersController < ApplicationController

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  layout "application"
  before_filter :require_user

  # GET /impact_leaders
  # GET /impact_leaders.xml
  def index
    @impact_leaders = ImpactLeader.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @impact_leaders }
    end
  end

  # GET /impact_leaders/1
  # GET /impact_leaders/1.xml
  def show
    @impact_leader = ImpactLeader.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @impact_leader }
    end
  end

  # GET /impact_leaders/new
  # GET /impact_leaders/new.xml
  def new
    @impact_leader = ImpactLeader.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @impact_leader }
    end
  end

  # GET /impact_leaders/1/edit
  def edit
    @impact_leader = ImpactLeader.find(params[:id])
  end

  # POST /impact_leaders
  # POST /impact_leaders.xml
  def create
    @impact_leader = ImpactLeader.new(params[:impact_leader])

    respond_to do |format|
      if @impact_leader.save
        flash[:notice] = 'ImpactLeader was successfully created.'
        format.html { redirect_to(@impact_leader) }
        format.xml  { render :xml => @impact_leader, :status => :created, :location => @impact_leader }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @impact_leader.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /impact_leaders/1
  # PUT /impact_leaders/1.xml
  def update
    @impact_leader = ImpactLeader.find(params[:id])

    respond_to do |format|
      if @impact_leader.update_attributes(params[:impact_leader])
        flash[:notice] = 'ImpactLeader was successfully updated.'
        format.html { redirect_to(@impact_leader) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @impact_leader.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /impact_leaders/1
  # DELETE /impact_leaders/1.xml
  def destroy
    @impact_leader = ImpactLeader.find(params[:id])
    @impact_leader.destroy

    respond_to do |format|
      format.html { redirect_to(impact_leaders_url) }
      format.xml  { head :ok }
    end
  end
end
