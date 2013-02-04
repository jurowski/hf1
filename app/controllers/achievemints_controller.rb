class AchievemintsController < ApplicationController
  # GET /achievemints
  # GET /achievemints.xml
  def index
    @achievemints = Achievemint.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @achievemints }
    end
  end

  # GET /achievemints/1
  # GET /achievemints/1.xml
  def show
    @achievemint = Achievemint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @achievemint }
    end
  end

  # GET /achievemints/new
  # GET /achievemints/new.xml
  def new
    @achievemint = Achievemint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @achievemint }
    end
  end

  # GET /achievemints/1/edit
  def edit
    @achievemint = Achievemint.find(params[:id])
  end

  # POST /achievemints
  # POST /achievemints.xml
  def create
    @achievemint = Achievemint.new(params[:achievemint])

    respond_to do |format|
      if @achievemint.save
        flash[:notice] = 'Achievemint was successfully created.'
        format.html { redirect_to(@achievemint) }
        format.xml  { render :xml => @achievemint, :status => :created, :location => @achievemint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @achievemint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /achievemints/1
  # PUT /achievemints/1.xml
  def update
    @achievemint = Achievemint.find(params[:id])

    respond_to do |format|
      if @achievemint.update_attributes(params[:achievemint])
        flash[:notice] = 'Achievemint was successfully updated.'
        format.html { redirect_to(@achievemint) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @achievemint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /achievemints/1
  # DELETE /achievemints/1.xml
  def destroy
    @achievemint = Achievemint.find(params[:id])
    @achievemint.destroy

    respond_to do |format|
      format.html { redirect_to(achievemints_url) }
      format.xml  { head :ok }
    end
  end
end
