class ProgramTemplatesController < ApplicationController


  layout "application"


  # GET /program_templates
  # GET /program_templates.xml
  def index
    @program_templates = ProgramTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @program_templates }
    end
  end

  # GET /program_templates/1
  # GET /program_templates/1.xml
  def show
    @program_template = ProgramTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program_template }
    end
  end

  # GET /program_templates/new
  # GET /program_templates/new.xml
  def new
    @program_template = ProgramTemplate.new

    if params[:program_id]
      @program_template.program_id = params[:program_id].to_i
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program_template }
    end
  end

  # GET /program_templates/1/edit
  def edit
    @program_template = ProgramTemplate.find(params[:id])
  end

  # POST /program_templates
  # POST /program_templates.xml
  def create
    @program_template = ProgramTemplate.new(params[:program_template])

    respond_to do |format|
      if @program_template.save

        format.html {redirect_to("/programs/#{@program_template.program_id}")}

        # flash[:notice] = 'ProgramTemplate was successfully created.'
        # format.html { redirect_to(@program_template) }
        # format.xml  { render :xml => @program_template, :status => :created, :location => @program_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /program_templates/1
  # PUT /program_templates/1.xml
  def update
    @program_template = ProgramTemplate.find(params[:id])

    respond_to do |format|
      if @program_template.update_attributes(params[:program_template])
        flash[:notice] = 'ProgramTemplate was successfully updated.'
        format.html { redirect_to(@program_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /program_templates/1
  # DELETE /program_templates/1.xml
  def destroy
    @program_template = ProgramTemplate.find(params[:id])
    @program_template.destroy

    respond_to do |format|
      format.html { redirect_to("/programs/" + @program_template.program.id.to_s) }
      format.xml  { head :ok }
    end
  end
end
