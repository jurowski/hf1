class ProgramSessionsController < ApplicationController

  before_filter :require_user, :except => [:show, :index]
  before_filter :require_user_can_make_templates, :except => [:show, :index]
  before_filter :require_program_session_scope, :except => [:show, :index]


  # GET /program_sessions
  # GET /program_sessions.xml
  def index
    @program_sessions = ProgramSession.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @program_sessions }
    end
  end

  # GET /program_sessions/1
  # GET /program_sessions/1.xml
  def show
    @program_session = ProgramSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program_session }
    end
  end

  # GET /program_sessions/new
  # GET /program_sessions/new.xml
  def new
    @program_session = ProgramSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program_session }
    end
  end

  # GET /program_sessions/1/edit
  def edit
    @program_session = ProgramSession.find(params[:id])
  end

  # POST /program_sessions
  # POST /program_sessions.xml
  def create
    @program_session = ProgramSession.new(params[:program_session])

    respond_to do |format|
      if @program_session.save
        flash[:notice] = 'ProgramSession was successfully created.'
        format.html { redirect_to(@program_session) }
        format.xml  { render :xml => @program_session, :status => :created, :location => @program_session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /program_sessions/1
  # PUT /program_sessions/1.xml
  def update
    @program_session = ProgramSession.find(params[:id])

    respond_to do |format|
      if @program_session.update_attributes(params[:program_session])
        flash[:notice] = 'ProgramSession was successfully updated.'
        format.html { redirect_to(@program_session) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /program_sessions/1
  # DELETE /program_sessions/1.xml
  def destroy
    @program_session = ProgramSession.find(params[:id])
    @program_session.destroy

    respond_to do |format|
      format.html { redirect_to(program_sessions_url) }
      format.xml  { head :ok }
    end
  end
end
