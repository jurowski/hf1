class TemplateAchievemintsController < ApplicationController
  # GET /template_achievemints
  # GET /template_achievemints.xml
  def index
    @template_achievemints = TemplateAchievemint.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @template_achievemints }
    end
  end

  # GET /template_achievemints/1
  # GET /template_achievemints/1.xml
  def show
    @template_achievemint = TemplateAchievemint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @template_achievemint }
    end
  end

  # GET /template_achievemints/new
  # GET /template_achievemints/new.xml
  def new
    @template_achievemint = TemplateAchievemint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @template_achievemint }
    end
  end

  # GET /template_achievemints/1/edit
  def edit
    @template_achievemint = TemplateAchievemint.find(params[:id])
  end

  # POST /template_achievemints
  # POST /template_achievemints.xml
  def create
    @template_achievemint = TemplateAchievemint.new(params[:template_achievemint])

    respond_to do |format|
      if @template_achievemint.save
        flash[:notice] = 'TemplateAchievemint was successfully created.'
        format.html { redirect_to(@template_achievemint) }
        format.xml  { render :xml => @template_achievemint, :status => :created, :location => @template_achievemint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @template_achievemint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /template_achievemints/1
  # PUT /template_achievemints/1.xml
  def update
    @template_achievemint = TemplateAchievemint.find(params[:id])

    respond_to do |format|
      if @template_achievemint.update_attributes(params[:template_achievemint])
        flash[:notice] = 'TemplateAchievemint was successfully updated.'
        format.html { redirect_to(@template_achievemint) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @template_achievemint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /template_achievemints/1
  # DELETE /template_achievemints/1.xml
  def destroy
    @template_achievemint = TemplateAchievemint.find(params[:id])
    @template_achievemint.destroy

    respond_to do |format|
      format.html { redirect_to(template_achievemints_url) }
      format.xml  { head :ok }
    end
  end
end
