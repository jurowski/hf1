class ProgramsController < ApplicationController

  layout "application"

  before_filter :require_user, :except => [:view]
  before_filter :require_user_can_make_templates, :except => [:view]
  before_filter :require_program_scope, :except => [:view]

  ### Do you want to be able to create new users when someone is logged in?
  #before_filter :require_no_user, :only => [:new, :create]
  # before_filter :require_no_user, :only => [:quicksignup_v2]
  # before_filter :require_user, :only => [:show, :edit, :update, :index, :destroy, :profile]
  #before_filter :require_user, :only => [:show, :edit, :update]


  # GET /programs
  # GET /programs.xml
  def index

    @programs = Array.new()
    if current_user.is_admin
      @programs = Program.all
    else
      @programs = Program.find(:all, :conditions => "managed_by_user_id = '#{current_user.id}'")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @programs }
    end
  end

  # GET /programs/1
  # GET /programs/1.xml
  def show
    @program = Program.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program }
    end
  end


  # GET /programs/1
  # GET /programs/1.xml
  def view
    @program = Program.find(params[:id])

    respond_to do |format|
      format.html # view.html.erb
      format.xml  { render :xml => @program }
    end
  end

  # GET /programs/new
  # GET /programs/new.xml
  def new
    @program = Program.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program }
    end
  end

  # GET /programs/1/edit
  def edit
    @program = Program.find(params[:id])
  end

  # POST /programs
  # POST /programs.xml
  def create
    @program = Program.new(params[:program])

    @program.managed_by_user_id = current_user.id

    respond_to do |format|
      if @program.save
        flash[:notice] = 'Program was successfully created.'
        #format.html { redirect_to(@program) }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program, :status => :created, :location => @program }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /programs/1
  # PUT /programs/1.xml
  def update
    @program = Program.find(params[:id])

    respond_to do |format|
      if @program.update_attributes(params[:program])
        flash[:notice] = 'Program was successfully updated.'
        format.html { redirect_to(@program) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.xml
  def destroy
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |format|
      format.html { redirect_to(programs_url) }
      format.xml  { head :ok }
    end
  end
end
