class QuotetagsController < ApplicationController
  # GET /quotetags
  # GET /quotetags.xml
  def index
    @quotetags = Quotetags.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotetags }
    end
  end

  # GET /quotetags/1
  # GET /quotetags/1.xml
  def show
    @quotetags = Quotetags.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quotetags }
    end
  end

  # GET /quotetags/new
  # GET /quotetags/new.xml
  def new
    @quotetags = Quotetags.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quotetags }
    end
  end

  # GET /quotetags/1/edit
  def edit
    @quotetags = Quotetags.find(params[:id])
  end

  # POST /quotetags
  # POST /quotetags.xml
  def create
    @quotetags = Quotetags.new(params[:quotetags])

    respond_to do |format|
      if @quotetags.save
        flash[:notice] = 'Quotetags was successfully created.'
        format.html { redirect_to(@quotetags) }
        format.xml  { render :xml => @quotetags, :status => :created, :location => @quotetags }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quotetags.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quotetags/1
  # PUT /quotetags/1.xml
  def update
    @quotetags = Quotetags.find(params[:id])

    respond_to do |format|
      if @quotetags.update_attributes(params[:quotetags])
        flash[:notice] = 'Quotetags was successfully updated.'
        format.html { redirect_to(@quotetags) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quotetags.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quotetags/1
  # DELETE /quotetags/1.xml
  def destroy
    @quotetags = Quotetags.find(params[:id])
    @quotetags.destroy

    respond_to do |format|
      format.html { redirect_to(quotetags_url) }
      format.xml  { head :ok }
    end
  end
end
