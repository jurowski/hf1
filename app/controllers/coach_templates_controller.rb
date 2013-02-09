class CoachTemplatesController < ApplicationController
  # GET /coach_templates
  # GET /coach_templates.xml
  def index
    @coach_templates = CoachTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coach_templates }
    end
  end

  # GET /coach_templates/1
  # GET /coach_templates/1.xml
  def show
    @coach_template = CoachTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @coach_template }
    end
  end

  # GET /coach_templates/new
  # GET /coach_templates/new.xml
  def new
    @coach_template = CoachTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coach_template }
    end
  end

  # GET /coach_templates/1/edit
  def edit
    @coach_template = CoachTemplate.find(params[:id])
  end

  # POST /coach_templates
  # POST /coach_templates.xml
  def create
    @coach_template = CoachTemplate.new(params[:coach_template])

    respond_to do |format|
      if @coach_template.save
        flash[:notice] = 'CoachTemplate was successfully created.'
        format.html { redirect_to(@coach_template) }
        format.xml  { render :xml => @coach_template, :status => :created, :location => @coach_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coach_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /coach_templates/1
  # PUT /coach_templates/1.xml
  def update
    @coach_template = CoachTemplate.find(params[:id])

    respond_to do |format|
      if @coach_template.update_attributes(params[:coach_template])
        flash[:notice] = 'CoachTemplate was successfully updated.'
        format.html { redirect_to(@coach_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @coach_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /coach_templates/1
  # DELETE /coach_templates/1.xml
  def destroy
    @coach_template = CoachTemplate.find(params[:id])
    @coach_template.destroy

    respond_to do |format|
      format.html { redirect_to(coach_templates_url) }
      format.xml  { head :ok }
    end
  end
end
