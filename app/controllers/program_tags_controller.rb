class ProgramTagsController < ApplicationController




  ### http://stackoverflow.com/questions/10539143/reloading-partial-in-an-rails-app
  # GET /template_tags/manage
  def manage

    @program = Program.new()
    if params[:add_tag_to_program] and params[:program_id] and params[:tag_id]
        @program = Program.find(params[:program_id].to_i)
        program_tag = ProgramTag.new()
        program_tag.tag_id = params[:tag_id].to_i
        program_tag.program_id = params[:program_id].to_i

        ### do not allow duplicates
        check_program_tag = ProgramTag.find(:first, :conditions => "program_id = '#{@program.id.to_i}' and tag_id = '#{params[:tag_id].to_i}'")
        if !check_program_tag
          program_tag.save
        end

    end

    if params[:remove_tag_from_program] and params[:program_id] and params[:tag_id]
        @program = Program.find(params[:program_id].to_i)
        program_tag = ProgramTag.find(:first, :conditions => "program_id = '#{params[:program_id]}' and tag_id = '#{params[:tag_id]}'")
        program_tag.destroy if program_tag
    end

    render :partial => "program_tags/manage", :locals => { :program => @program } 
  end


  # GET /program_tags
  # GET /program_tags.xml
  def index
    @program_tags = ProgramTag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @program_tags }
    end
  end

  # GET /program_tags/1
  # GET /program_tags/1.xml
  def show
    @program_tag = ProgramTag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program_tag }
    end
  end

  # GET /program_tags/new
  # GET /program_tags/new.xml
  def new
    @program_tag = ProgramTag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program_tag }
    end
  end

  # GET /program_tags/1/edit
  def edit
    @program_tag = ProgramTag.find(params[:id])
  end

  # POST /program_tags
  # POST /program_tags.xml
  def create
    @program_tag = ProgramTag.new(params[:program_tag])

    respond_to do |format|
      if @program_tag.save
        flash[:notice] = 'ProgramTag was successfully created.'
        format.html { redirect_to(@program_tag) }
        format.xml  { render :xml => @program_tag, :status => :created, :location => @program_tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /program_tags/1
  # PUT /program_tags/1.xml
  def update
    @program_tag = ProgramTag.find(params[:id])

    respond_to do |format|
      if @program_tag.update_attributes(params[:program_tag])
        flash[:notice] = 'ProgramTag was successfully updated.'
        format.html { redirect_to(@program_tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /program_tags/1
  # DELETE /program_tags/1.xml
  def destroy
    @program_tag = ProgramTag.find(params[:id])
    @program_tag.destroy

    respond_to do |format|
      format.html { redirect_to(program_tags_url) }
      format.xml  { head :ok }
    end
  end
end
