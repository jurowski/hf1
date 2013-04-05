class OrganizationUsersController < ApplicationController
  # GET /organization_users
  # GET /organization_users.xml
  def index
    @organization_users = OrganizationUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organization_users }
    end
  end

  # GET /organization_users/1
  # GET /organization_users/1.xml
  def show
    @organization_user = OrganizationUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization_user }
    end
  end

  # GET /organization_users/new
  # GET /organization_users/new.xml
  def new
    @organization_user = OrganizationUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization_user }
    end
  end

  # GET /organization_users/1/edit
  def edit
    @organization_user = OrganizationUser.find(params[:id])
  end

  # POST /organization_users
  # POST /organization_users.xml
  def create
    @organization_user = OrganizationUser.new(params[:organization_user])

    respond_to do |format|
      if @organization_user.save
        flash[:notice] = 'OrganizationUser was successfully created.'
        format.html { redirect_to(@organization_user) }
        format.xml  { render :xml => @organization_user, :status => :created, :location => @organization_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organization_users/1
  # PUT /organization_users/1.xml
  def update
    @organization_user = OrganizationUser.find(params[:id])

    respond_to do |format|
      if @organization_user.update_attributes(params[:organization_user])
        flash[:notice] = 'OrganizationUser was successfully updated.'
        format.html { redirect_to(@organization_user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_users/1
  # DELETE /organization_users/1.xml
  def destroy
    @organization_user = OrganizationUser.find(params[:id])
    @organization_user.destroy

    respond_to do |format|
      format.html { redirect_to(organization_users_url) }
      format.xml  { head :ok }
    end
  end
end
