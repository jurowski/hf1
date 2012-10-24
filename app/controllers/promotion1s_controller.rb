class Promotion1sController < ApplicationController

  before_filter :require_admin_user

  # GET /promotion1s
  # GET /promotion1s.xml
  def index
    @promotion1s = Promotion1.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @promotion1s }
    end
  end

  # GET /promotion1s/1
  # GET /promotion1s/1.xml
  def show
    @promotion1 = Promotion1.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @promotion1 }
    end
  end

  # GET /promotion1s/new
  # GET /promotion1s/new.xml
  def new
    @promotion1 = Promotion1.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @promotion1 }
    end
  end

  # GET /promotion1s/1/edit
  def edit
    @promotion1 = Promotion1.find(params[:id])
  end

  # POST /promotion1s
  # POST /promotion1s.xml
  def create
    @promotion1 = Promotion1.new(params[:promotion1])

    respond_to do |format|
      if @promotion1.save
        flash[:notice] = 'Promotion1 was successfully created.'
        format.html { redirect_to(@promotion1) }
        format.xml  { render :xml => @promotion1, :status => :created, :location => @promotion1 }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @promotion1.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /promotion1s/1
  # PUT /promotion1s/1.xml
  def update
    @promotion1 = Promotion1.find(params[:id])

    respond_to do |format|
      if @promotion1.update_attributes(params[:promotion1])
        flash[:notice] = 'Promotion1 was successfully updated.'
        format.html { redirect_to(@promotion1) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @promotion1.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /promotion1s/1
  # DELETE /promotion1s/1.xml
  def destroy
    @promotion1 = Promotion1.find(params[:id])
    @promotion1.destroy

    respond_to do |format|
      format.html { redirect_to(promotion1s_url) }
      format.xml  { head :ok }
    end
  end
end
