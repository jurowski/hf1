class TemplateTagsController < ApplicationController


  ### http://stackoverflow.com/questions/10539143/reloading-partial-in-an-rails-app
  # GET /template_tags/manage
  def manage

    @goal = Goal.new()
    if params[:add_tag_to_template] and params[:goal_id] and params[:tag_id]
        @goal = Goal.find(params[:goal_id].to_i)
        template_tag = TemplateTag.new()
        template_tag.tag_id = params[:tag_id].to_i
        template_tag.template_goal_id = params[:goal_id].to_i
        template_tag.save
    end

    if params[:remove_tag_from_template] and params[:goal_id] and params[:tag_id]
        @goal = Goal.find(params[:goal_id].to_i)
        template_tag = TemplateTag.find(:first, :conditions => "template_goal_id = '#{params[:goal_id]}' and tag_id = '#{params[:tag_id]}'")
        template_tag.destroy if template_tag
    end

    render :partial => "template_tags/manage", :locals => { :goal => @goal } 
  end


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
