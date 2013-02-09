class CoachMotivationTypesController < ApplicationController
  # GET /coach_motivation_types
  # GET /coach_motivation_types.xml
  def index
    @coach_motivation_types = CoachMotivationType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coach_motivation_types }
    end
  end

  # GET /coach_motivation_types/1
  # GET /coach_motivation_types/1.xml
  def show
    @coach_motivation_type = CoachMotivationType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @coach_motivation_type }
    end
  end

  # GET /coach_motivation_types/new
  # GET /coach_motivation_types/new.xml
  def new
    @coach_motivation_type = CoachMotivationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coach_motivation_type }
    end
  end

  # GET /coach_motivation_types/1/edit
  def edit
    @coach_motivation_type = CoachMotivationType.find(params[:id])
  end

  # POST /coach_motivation_types
  # POST /coach_motivation_types.xml
  def create
    @coach_motivation_type = CoachMotivationType.new(params[:coach_motivation_type])

    respond_to do |format|
      if @coach_motivation_type.save
        flash[:notice] = 'CoachMotivationType was successfully created.'
        format.html { redirect_to(@coach_motivation_type) }
        format.xml  { render :xml => @coach_motivation_type, :status => :created, :location => @coach_motivation_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coach_motivation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /coach_motivation_types/1
  # PUT /coach_motivation_types/1.xml
  def update
    @coach_motivation_type = CoachMotivationType.find(params[:id])

    respond_to do |format|
      if @coach_motivation_type.update_attributes(params[:coach_motivation_type])
        flash[:notice] = 'CoachMotivationType was successfully updated.'
        format.html { redirect_to(@coach_motivation_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @coach_motivation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /coach_motivation_types/1
  # DELETE /coach_motivation_types/1.xml
  def destroy
    @coach_motivation_type = CoachMotivationType.find(params[:id])
    @coach_motivation_type.destroy

    respond_to do |format|
      format.html { redirect_to(coach_motivation_types_url) }
      format.xml  { head :ok }
    end
  end
end
