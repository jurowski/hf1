class TemplateTagsController < ApplicationController
  # GET /template_tags
  # GET /template_tags.xml
  def index
    @template_tags = TemplateTag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @template_tags }
    end
  end

  # GET /template_tags/1
  # GET /template_tags/1.xml
  def show
    @template_tag = TemplateTag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @template_tag }
    end
  end

  # GET /template_tags/new
  # GET /template_tags/new.xml
  def new
    @template_tag = TemplateTag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @template_tag }
    end
  end

  # GET /template_tags/1/edit
  def edit
    @template_tag = TemplateTag.find(params[:id])
  end

  # POST /template_tags
  # POST /template_tags.xml
  def create
    @template_tag = TemplateTag.new(params[:template_tag])

    respond_to do |format|
      if @template_tag.save
        flash[:notice] = 'TemplateTag was successfully created.'
        format.html { redirect_to(@template_tag) }
        format.xml  { render :xml => @template_tag, :status => :created, :location => @template_tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @template_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /template_tags/1
  # PUT /template_tags/1.xml
  def update
    @template_tag = TemplateTag.find(params[:id])

    respond_to do |format|
      if @template_tag.update_attributes(params[:template_tag])
        flash[:notice] = 'TemplateTag was successfully updated.'
        format.html { redirect_to(@template_tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @template_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /template_tags/1
  # DELETE /template_tags/1.xml
  def destroy
    @template_tag = TemplateTag.find(params[:id])
    @template_tag.destroy

    respond_to do |format|
      format.html { redirect_to(template_tags_url) }
      format.xml  { head :ok }
    end
  end
end
