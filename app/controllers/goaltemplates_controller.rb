class GoaltemplatesController < ApplicationController

  before_filter :require_admin_user

  # GET /goaltemplates
  # GET /goaltemplates.xml
  def index
    @goaltemplates = Goaltemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @goaltemplates }
    end
  end

  # GET /goaltemplates/1
  # GET /goaltemplates/1.xml
  def show
    @goaltemplate = Goaltemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @goaltemplate }
    end
  end

  # GET /goaltemplates/new
  # GET /goaltemplates/new.xml
  def new
    @goaltemplate = Goaltemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @goaltemplate }
    end
  end

  # GET /goaltemplates/1/edit
  def edit
    @goaltemplate = Goaltemplate.find(params[:id])
  end

  # POST /goaltemplates
  # POST /goaltemplates.xml
  def create
    @goaltemplate = Goaltemplate.new(params[:goaltemplate])

    respond_to do |format|
      if @goaltemplate.save
        flash[:notice] = 'Goaltemplate was successfully created.'
        format.html { redirect_to("/goaltemplates/new") }
        format.xml  { render :xml => @goaltemplate, :status => :created, :location => @goaltemplate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @goaltemplate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /goaltemplates/1
  # PUT /goaltemplates/1.xml
  def update
    @goaltemplate = Goaltemplate.find(params[:id])

    respond_to do |format|
      if @goaltemplate.update_attributes(params[:goaltemplate])
        flash[:notice] = 'Goaltemplate was successfully updated.'
        format.html { redirect_to(@goaltemplate) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @goaltemplate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /goaltemplates/1
  # DELETE /goaltemplates/1.xml
  def destroy
    @goaltemplate = Goaltemplate.find(params[:id])
    @goaltemplate.destroy

    respond_to do |format|
      format.html { redirect_to(goaltemplates_url) }
      format.xml  { head :ok }
    end
  end
end
