class UserRemovedsController < ApplicationController
  # GET /user_removeds
  # GET /user_removeds.xml
  def index
    @user_removeds = UserRemoved.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_removeds }
    end
  end

  # GET /user_removeds/1
  # GET /user_removeds/1.xml
  def show
    @user_removed = UserRemoved.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_removed }
    end
  end

  # GET /user_removeds/new
  # GET /user_removeds/new.xml
  def new
    @user_removed = UserRemoved.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_removed }
    end
  end

  # GET /user_removeds/1/edit
  def edit
    @user_removed = UserRemoved.find(params[:id])
  end

  # POST /user_removeds
  # POST /user_removeds.xml
  def create
    @user_removed = UserRemoved.new(params[:user_removed])

    respond_to do |format|
      if @user_removed.save
        flash[:notice] = 'UserRemoved was successfully created.'
        format.html { redirect_to(@user_removed) }
        format.xml  { render :xml => @user_removed, :status => :created, :location => @user_removed }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_removed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_removeds/1
  # PUT /user_removeds/1.xml
  def update
    @user_removed = UserRemoved.find(params[:id])

    respond_to do |format|
      if @user_removed.update_attributes(params[:user_removed])
        flash[:notice] = 'UserRemoved was successfully updated.'
        format.html { redirect_to(@user_removed) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_removed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_removeds/1
  # DELETE /user_removeds/1.xml
  def destroy
    @user_removed = UserRemoved.find(params[:id])
    @user_removed.destroy

    respond_to do |format|
      format.html { redirect_to(user_removeds_url) }
      format.xml  { head :ok }
    end
  end
end
