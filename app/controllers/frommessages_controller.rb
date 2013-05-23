class FrommessagesController < ApplicationController



  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  layout "application"


  before_filter :require_user
  
  # GET /frommessages
  # GET /frommessages.xml
  def index
    @frommessages = Frommessage.find(:all, :conditions => "from_id = '#{current_user.id}'")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @frommessages }
    end
  end

  # GET /frommessages/1
  # GET /frommessages/1.xml
  def show
    @frommessage = Frommessage.find(params[:id])

    @to_user = User.find(:first, :conditions => "id = '#{@frommessage.to_id}'")

    if current_user.id == @frommessage.from_id
        @frommessage.unread = 0
        @frommessage.save
    end


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @frommessage }
    end
  end

  # GET /frommessages/new
  # GET /frommessages/new.xml
  def new
    @frommessage = Frommessage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @frommessage }
    end
  end

  # GET /frommessages/1/edit
  #def edit
  #  @frommessage = Frommessage.find(params[:id])
  #end

  # POST /frommessages
  # POST /frommessages.xml
  def create
    @frommessage = Frommessage.new(params[:frommessage])

    respond_to do |format|
      if @frommessage.save
        flash[:notice] = 'Frommessage was successfully created.'
        format.html { redirect_to(@frommessage) }
        format.xml  { render :xml => @frommessage, :status => :created, :location => @frommessage }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @frommessage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /frommessages/1
  # PUT /frommessages/1.xml
  #def update
  #  @frommessage = Frommessage.find(params[:id])
  #
  #  respond_to do |format|
  #    if @frommessage.update_attributes(params[:frommessage])
  #      flash[:notice] = 'Frommessage was successfully updated.'
  #      format.html { redirect_to(@frommessage) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @frommessage.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /frommessages/1
  # DELETE /frommessages/1.xml
  def destroy
    @frommessage = Frommessage.find(params[:id])
    @frommessage.destroy

    respond_to do |format|
      format.html { redirect_to(frommessages_url) }
      format.xml  { head :ok }
    end
  end
end
