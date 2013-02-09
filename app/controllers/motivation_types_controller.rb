class MotivationTypesController < ApplicationController
  # GET /motivation_types
  # GET /motivation_types.xml
  def index
    @motivation_types = MotivationType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @motivation_types }
    end
  end

  # GET /motivation_types/1
  # GET /motivation_types/1.xml
  def show
    @motivation_type = MotivationType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @motivation_type }
    end
  end

  # GET /motivation_types/new
  # GET /motivation_types/new.xml
  def new
    @motivation_type = MotivationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @motivation_type }
    end
  end

  # GET /motivation_types/1/edit
  def edit
    @motivation_type = MotivationType.find(params[:id])
  end

  # POST /motivation_types
  # POST /motivation_types.xml
  def create
    @motivation_type = MotivationType.new(params[:motivation_type])

    respond_to do |format|
      if @motivation_type.save
        flash[:notice] = 'MotivationType was successfully created.'
        format.html { redirect_to(@motivation_type) }
        format.xml  { render :xml => @motivation_type, :status => :created, :location => @motivation_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @motivation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /motivation_types/1
  # PUT /motivation_types/1.xml
  def update
    @motivation_type = MotivationType.find(params[:id])

    respond_to do |format|
      if @motivation_type.update_attributes(params[:motivation_type])
        flash[:notice] = 'MotivationType was successfully updated.'
        format.html { redirect_to(@motivation_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @motivation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /motivation_types/1
  # DELETE /motivation_types/1.xml
  def destroy
    @motivation_type = MotivationType.find(params[:id])
    @motivation_type.destroy

    respond_to do |format|
      format.html { redirect_to(motivation_types_url) }
      format.xml  { head :ok }
    end
  end
end
