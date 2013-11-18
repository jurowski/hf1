class UserFriendsController < ApplicationController

  require 'date'
  require 'logger'

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  layout "application"

  ### see "applicatoin_controller.rb"...  
  #before_filter :require_user, :only => [:single, :show, :new, :edit, :destroy, :update, :invite_a_friend_to_track]
  before_filter :require_user



  # GET /user_friends
  # GET /user_friends.xml
  def index
    @user_friends = UserFriend.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_friends }
    end
  end

  # GET /user_friends/1
  # GET /user_friends/1.xml
  def show
    @user_friend = UserFriend.find(params[:id])

    if current_user.id != @user_friend.user_id
      redirect_to(server_root_url)        
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user_friend }
      end
    end

  end

  # GET /user_friends/new
  # GET /user_friends/new.xml
  def new
    @user_friend = UserFriend.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_friend }
    end
  end

  # GET /user_friends/1/edit
  def edit
    @user_friend = UserFriend.find(params[:id])

    if current_user.id != @user_friend.user_id
      redirect_to(server_root_url)        
    end

  end

  # POST /user_friends
  # POST /user_friends.xml
  def create
    @user_friend = UserFriend.new(params[:user_friend])

    if current_user.id != @user_friend.user_id
      redirect_to(server_root_url)        
    else

      respond_to do |format|
        if @user_friend.save
          flash[:notice] = 'UserFriend was successfully created.'
          format.html { redirect_to(@user_friend) }
          format.xml  { render :xml => @user_friend, :status => :created, :location => @user_friend }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @user_friend.errors, :status => :unprocessable_entity }
        end
      end

    end


  end

  # PUT /user_friends/1
  # PUT /user_friends/1.xml
  def update
    @user_friend = UserFriend.find(params[:id])

    if current_user.id != @user_friend.user_id
      redirect_to(server_root_url)        
    else


      respond_to do |format|
        if @user_friend.update_attributes(params[:user_friend])
          flash[:notice] = 'UserFriend was successfully updated.'
          format.html { redirect_to(@user_friend) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user_friend.errors, :status => :unprocessable_entity }
        end
      end


    end

  end

  # DELETE /user_friends/1
  # DELETE /user_friends/1.xml
  def destroy
    @user_friend = UserFriend.find(params[:id])

    if current_user.id != @user_friend.user_id
      redirect_to(server_root_url)        
    else


      @user_friend.destroy

      respond_to do |format|
        format.html { redirect_to(user_friends_url) }
        format.xml  { head :ok }
      end


    end


  end ### end of def destroy



end ### end of class
