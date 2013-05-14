class TagsController < ApplicationController

  before_filter :require_admin_user


  # GET /tags
  # GET /tags.xml
  def index
    redirect_to "/tags/new"
  end

  # GET /tags/1
  # GET /tags/1.xml
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.xml
  def new
    @tags = Tag.find(:all, :order => "name")
    
    @tag = Tag.new
    @tag.shared = true
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.xml
  def create
    @tag = Tag.new(params[:tag])

    @tag.name = @tag.name.gsub(" ", "_")
    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Tag was successfully created.'
        format.html { redirect_to("/tags/new") }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])

        ### re-save but w/ spaces changed
        @tag.name = @tag.name.gsub(" ", "_")
        @tag.save

        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to("/tags/new") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])


    destroy_me = false

    @still_assigned_so_do_not_delete_tag = TemplateTag.find(:all, :conditions => "tag_id = '#{@tag.id}'")
    if @still_assigned_so_do_not_delete_tag and @still_assigned_so_do_not_delete_tag.size > 0
      flash[:error] = 'Tag could not be deleted. (It is assigned to ' + @still_assigned_so_do_not_delete_tag.size.to_s + ' templates.'
    else
      destroy_me = true
    end

    @still_assigned_so_do_not_delete_tag = ProgramTag.find(:all, :conditions => "tag_id = '#{@tag.id}'")
    if @still_assigned_so_do_not_delete_tag and @still_assigned_so_do_not_delete_tag.size > 0
      flash[:error] = 'Tag could not be deleted. (It is assigned to ' + @still_assigned_so_do_not_delete_tag.size.to_s + ' programs.'
    else
      destroy_me = true
    end


    if destroy_me
      @tag.destroy
    end

    respond_to do |format|
      format.html { redirect_to("/tags/new") }
      format.xml  { head :ok }
    end
  end
end
