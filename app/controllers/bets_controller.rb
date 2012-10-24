class BetsController < ApplicationController
  #before_filter :require_user

  #before_filter :require_admin_user, :only => [:show, :edit, :update, :index, :destroy]
  before_filter :require_admin_user

  
  # GET /bets
  # GET /bets.xml
  def index
    @bets = Bet.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bets }
    end
  end

  # GET /bets/1
  # GET /bets/1.xml
  def show
    @bet = Bet.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bet }
    end
  end

  # GET /bets/new
  # GET /bets/new.xml
  def new
    @bet = Bet.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bet }
    end
  end

  # GET /bets/1/edit
  def edit
    @bet = Bet.find(params[:id])
  end

  # POST /bets
  # POST /bets.xml
  def create
    @bet = Bet.new(params[:bet])
    respond_to do |format|
      if @bet.save
        flash[:notice] = 'Bet was successfully created.'
        format.html { redirect_to(@bet) }
        format.xml  { render :xml => @bet, :status => :created, :location => @bet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bets/1
  # PUT /bets/1.xml
  def update
    @bet = Bet.find(params[:id])
    respond_to do |format|
      if @bet.update_attributes(params[:bet])
        flash[:notice] = 'Bet was successfully updated.'
        format.html { redirect_to(@bet) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.xml
  def destroy
    @bet = Bet.find(params[:id])
    @bet.destroy

    respond_to do |format|
      format.html { redirect_to(bets_url) }
      format.xml  { head :ok }
    end
  end
end
