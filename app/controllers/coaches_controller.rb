class CoachesController < ApplicationController
  include CoachgoalsHelper

  layout "application"

  before_filter :require_user
  before_filter :require_admin_user, :only => [:create, :new, :index, :destroy]
  
  # GET /coaches
  # GET /coaches.xml
  def index
    @coaches = Coach.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coaches }
    end
  end

  # GET /coaches/1
  # GET /coaches/1.xml
  def show
    ### Only show if the coach in question is accessing it (or admin)
    @coach = Coach.find(params[:id])
    if @coach != nil
        if current_user_is_admin or current_user.id == @coach.user_id
            respond_to do |format|
              format.html # show.html.erb
              format.xml  { render :xml => @coach }
            end
        else
            redirect_to new_user_session_url
            return false
        end
    else
        redirect_to new_user_session_url
        return false
    end
  end

  # GET /coaches/new
  # GET /coaches/new.xml
  def new
    @coach = Coach.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coach }
    end  
  end

  # GET /coaches/1/edit
  def edit


    ### Only show if the coach in question is accessing it (or admin)
    @coach = Coach.find(params[:id])
    if @coach != nil
        if current_user_is_admin or current_user.id == @coach.user_id
            respond_to do |format|
              format.html # show.html.erb
              format.xml  { render :xml => @coach }
            end
        else
            redirect_to new_user_session_url
            return false
        end
    else
        redirect_to new_user_session_url
        return false
    end

  end

  # POST /coaches
  # POST /coaches.xml
  def create
    @coach = Coach.new(params[:coach])

    respond_to do |format|
      if @coach.save
        flash[:notice] = 'Coach was successfully created.'
        format.html { redirect_to(@coach) }
        format.xml  { render :xml => @coach, :status => :created, :location => @coach }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coach.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /coaches/1
  # PUT /coaches/1.xml
  def update

    ### Only show if the coach in question is accessing it (or admin)
    @coach = Coach.find(params[:id])
    if @coach != nil
        if current_user_is_admin or current_user.id == @coach.user_id
            @coach = Coach.find(params[:id])

            respond_to do |format|
              if @coach.update_attributes(params[:coach])
                flash[:notice] = 'Coach was successfully updated.'
                format.html { redirect_to(@coach) }
                format.xml  { head :ok }
              else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @coach.errors, :status => :unprocessable_entity }
              end
            end
        else
            redirect_to new_user_session_url
            return false
        end
    else
        redirect_to new_user_session_url
        return false
    end

  end

  # DELETE /coaches/1
  # DELETE /coaches/1.xml
  def destroy
    @coach = Coach.find(params[:id])
    @coach.destroy

    respond_to do |format|
      format.html { redirect_to(coaches_url) }
      format.xml  { head :ok }
    end
  end
end
