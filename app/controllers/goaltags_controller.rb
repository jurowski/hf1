class GoaltagsController < ApplicationController

  before_filter :require_admin_user


  # GET /goaltags
  # GET /goaltags.xml
  def index
    @goaltags = Goaltag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @goaltags }
    end
  end

  # GET /goaltags/1
  # GET /goaltags/1.xml
  def show
    @goaltag = Goaltag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @goaltag }
    end
  end

  # GET /goaltags/new
  # GET /goaltags/new.xml
  def new
    @goaltag = Goaltag.new

    @goaltemplates = Goaltemplate.all
    @tags = Tag.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @goaltag }
    end
  end

  # GET /goaltags/1/edit
  def edit
    @goaltag = Goaltag.find(params[:id])
  end

  # POST /goaltags
  # POST /goaltags.xml
  def create
    @goaltag = Goaltag.new(params[:goaltag])

    respond_to do |format|
      if @goaltag.save
        flash[:notice] = 'Goaltag was successfully created.'
        format.html { redirect_to(@goaltag) }
        format.xml  { render :xml => @goaltag, :status => :created, :location => @goaltag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @goaltag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /goaltags/1
  # PUT /goaltags/1.xml
  def update
    @goaltag = Goaltag.find(params[:id])

    respond_to do |format|
      if @goaltag.update_attributes(params[:goaltag])
        flash[:notice] = 'Goaltag was successfully updated.'
        format.html { redirect_to(@goaltag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @goaltag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /goaltags/1
  # DELETE /goaltags/1.xml
  def destroy
    @goaltag = Goaltag.find(params[:id])
    @goaltag.destroy

    respond_to do |format|
      format.html { redirect_to(goaltags_url) }
      format.xml  { head :ok }
    end
  end
end
