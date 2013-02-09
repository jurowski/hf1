class UserMotivationTypesController < ApplicationController
  # GET /user_motivation_types
  # GET /user_motivation_types.xml
  def index
    @user_motivation_types = UserMotivationType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_motivation_types }
    end
  end

  # GET /user_motivation_types/1
  # GET /user_motivation_types/1.xml
  def show
    @user_motivation_type = UserMotivationType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_motivation_type }
    end
  end

  # GET /user_motivation_types/new
  # GET /user_motivation_types/new.xml
  def new
    @user_motivation_type = UserMotivationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_motivation_type }
    end
  end

  # GET /user_motivation_types/1/edit
  def edit
    @user_motivation_type = UserMotivationType.find(params[:id])
  end

  # POST /user_motivation_types
  # POST /user_motivation_types.xml
  def create
    @user_motivation_type = UserMotivationType.new(params[:user_motivation_type])

    respond_to do |format|
      if @user_motivation_type.save
        flash[:notice] = 'UserMotivationType was successfully created.'
        format.html { redirect_to(@user_motivation_type) }
        format.xml  { render :xml => @user_motivation_type, :status => :created, :location => @user_motivation_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_motivation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_motivation_types/1
  # PUT /user_motivation_types/1.xml
  def update
    @user_motivation_type = UserMotivationType.find(params[:id])

    respond_to do |format|
      if @user_motivation_type.update_attributes(params[:user_motivation_type])
        flash[:notice] = 'UserMotivationType was successfully updated.'
        format.html { redirect_to(@user_motivation_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_motivation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_motivation_types/1
  # DELETE /user_motivation_types/1.xml
  def destroy
    @user_motivation_type = UserMotivationType.find(params[:id])
    @user_motivation_type.destroy

    respond_to do |format|
      format.html { redirect_to(user_motivation_types_url) }
      format.xml  { head :ok }
    end
  end
end
