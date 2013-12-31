class ProgramEnrollmentsController < ApplicationController

  layout "application"

  before_filter :require_user
  before_filter :require_my_program_enrollment ### if showing an :id it has to be mine or i need to be admin


  # GET /program_enrollments
  # GET /program_enrollments.xml
  def index
    @program_enrollments = ProgramEnrollment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @program_enrollments }
    end
  end

  # GET /program_enrollments/1
  # GET /program_enrollments/1.xml
  def show
    @program_enrollment = ProgramEnrollment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program_enrollment }
    end
  end

  # GET /program_enrollments/new
  # GET /program_enrollments/new.xml
  def new
    @program_enrollment = ProgramEnrollment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program_enrollment }
    end
  end

  # GET /program_enrollments/1/edit
  def edit
    @program_enrollment = ProgramEnrollment.find(params[:id])
  end

  # POST /program_enrollments
  # POST /program_enrollments.xml
  def create
    @program_enrollment = ProgramEnrollment.new(params[:program_enrollment])

    respond_to do |format|
      if @program_enrollment.save
        flash[:notice] = 'ProgramEnrollment was successfully created.'
        format.html { redirect_to(@program_enrollment) }
        format.xml  { render :xml => @program_enrollment, :status => :created, :location => @program_enrollment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program_enrollment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /program_enrollments/1
  # PUT /program_enrollments/1.xml
  def update
    @program_enrollment = ProgramEnrollment.find(params[:id])

    respond_to do |format|
      if @program_enrollment.update_attributes(params[:program_enrollment])
        flash[:notice] = 'ProgramEnrollment was successfully updated.'
        format.html { redirect_to(@program_enrollment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program_enrollment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /program_enrollments/1
  # DELETE /program_enrollments/1.xml
  def destroy
    @program_enrollment = ProgramEnrollment.find(params[:id])
    @program_enrollment.destroy

    respond_to do |format|
      format.html { redirect_to(program_enrollments_url) }
      format.xml  { head :ok }
    end
  end
end
