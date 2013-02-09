class ProgramMotivationTypesController < ApplicationController
  # GET /program_motivation_types
  # GET /program_motivation_types.xml
  def index
    @program_motivation_types = ProgramMotivationType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @program_motivation_types }
    end
  end

  # GET /program_motivation_types/1
  # GET /program_motivation_types/1.xml
  def show
    @program_motivation_type = ProgramMotivationType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program_motivation_type }
    end
  end

  # GET /program_motivation_types/new
  # GET /program_motivation_types/new.xml
  def new
    @program_motivation_type = ProgramMotivationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program_motivation_type }
    end
  end

  # GET /program_motivation_types/1/edit
  def edit
    @program_motivation_type = ProgramMotivationType.find(params[:id])
  end

  # POST /program_motivation_types
  # POST /program_motivation_types.xml
  def create
    @program_motivation_type = ProgramMotivationType.new(params[:program_motivation_type])

    respond_to do |format|
      if @program_motivation_type.save
        flash[:notice] = 'ProgramMotivationType was successfully created.'
        format.html { redirect_to(@program_motivation_type) }
        format.xml  { render :xml => @program_motivation_type, :status => :created, :location => @program_motivation_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program_motivation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /program_motivation_types/1
  # PUT /program_motivation_types/1.xml
  def update
    @program_motivation_type = ProgramMotivationType.find(params[:id])

    respond_to do |format|
      if @program_motivation_type.update_attributes(params[:program_motivation_type])
        flash[:notice] = 'ProgramMotivationType was successfully updated.'
        format.html { redirect_to(@program_motivation_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program_motivation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /program_motivation_types/1
  # DELETE /program_motivation_types/1.xml
  def destroy
    @program_motivation_type = ProgramMotivationType.find(params[:id])
    @program_motivation_type.destroy

    respond_to do |format|
      format.html { redirect_to(program_motivation_types_url) }
      format.xml  { head :ok }
    end
  end
end
