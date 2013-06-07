class TeamInvitesController < ApplicationController
  # GET /team_invites
  # GET /team_invites.xml
  def index
    @team_invites = TeamInvite.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @team_invites }
    end
  end

  # GET /team_invites/1
  # GET /team_invites/1.xml
  def show
    @team_invite = TeamInvite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team_invite }
    end
  end

  # GET /team_invites/new
  # GET /team_invites/new.xml
  def new
    @team_invite = TeamInvite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team_invite }
    end
  end

  # GET /team_invites/1/edit
  def edit
    @team_invite = TeamInvite.find(params[:id])
  end

  # POST /team_invites
  # POST /team_invites.xml
  def create
    @team_invite = TeamInvite.new(params[:team_invite])

    respond_to do |format|
      if @team_invite.save
        flash[:notice] = 'TeamInvite was successfully created.'
        format.html { redirect_to(@team_invite) }
        format.xml  { render :xml => @team_invite, :status => :created, :location => @team_invite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team_invite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /team_invites/1
  # PUT /team_invites/1.xml
  def update
    @team_invite = TeamInvite.find(params[:id])

    respond_to do |format|
      if @team_invite.update_attributes(params[:team_invite])
        flash[:notice] = 'TeamInvite was successfully updated.'
        format.html { redirect_to(@team_invite) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team_invite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /team_invites/1
  # DELETE /team_invites/1.xml
  def destroy
    @team_invite = TeamInvite.find(params[:id])
    @team_invite.destroy

    respond_to do |format|
      format.html { redirect_to(team_invites_url) }
      format.xml  { head :ok }
    end
  end
end
