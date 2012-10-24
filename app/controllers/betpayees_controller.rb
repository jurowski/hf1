class BetpayeesController < ApplicationController
  #before_filter :require_user

  #before_filter :require_admin_user, :only => [:show, :edit, :update, :index, :destroy]
  before_filter :require_admin_user


  # GET /betpayees
  # GET /betpayees.xml
  def index
    @betpayees = Betpayee.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @betpayees }
    end
  end

  # GET /betpayees/1
  # GET /betpayees/1.xml
  def show
    @betpayee = Betpayee.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @betpayee }
    end
  end

  # GET /betpayees/new
  # GET /betpayees/new.xml
  def new
    @betpayee = Betpayee.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @betpayee }
    end
  end

  # GET /betpayees/1/edit
  def edit
    @betpayee = Betpayee.find(params[:id])
  end

  # POST /betpayees
  # POST /betpayees.xml
  def create
    @betpayee = Betpayee.new(params[:betpayee])
    respond_to do |format|
      if @betpayee.save
        flash[:notice] = 'Betpayee was successfully created.'
        format.html { redirect_to(@betpayee) }
        format.xml  { render :xml => @betpayee, :status => :created, :location => @betpayee }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @betpayee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /betpayees/1
  # PUT /betpayees/1.xml
  def update
    @betpayee = Betpayee.find(params[:id])
    respond_to do |format|
      if @betpayee.update_attributes(params[:betpayee])
        flash[:notice] = 'Betpayee was successfully updated.'
        format.html { redirect_to(@betpayee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @betpayee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /betpayees/1
  # DELETE /betpayees/1.xml
  def destroy
    @betpayee = Betpayee.find(params[:id])
    @betpayee.destroy

    respond_to do |format|
      format.html { redirect_to(betpayees_url) }
      format.xml  { head :ok }
    end
  end
end
