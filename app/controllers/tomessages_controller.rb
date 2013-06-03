class TomessagesController < ApplicationController
  # GET /tomessages
  # GET /tomessages.xml


  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'
  
  layout "application"

  before_filter :require_user

  def index
    @tomessages = Tomessage.find(:all, :conditions => "to_id = '#{current_user.id}'")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tomessages }
    end
  end

  # GET /tomessages/1
  # GET /tomessages/1.xml
  def show
    @tomessage = Tomessage.find(params[:id])

    if current_user.id == @tomessage.to_id
        @tomessage.unread = 0
        @tomessage.save
    end

    @from_user = User.find(:first, :conditions => "id = '#{@tomessage.from_id}'")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tomessage }
    end
  end

  # GET /tomessages/new
  # GET /tomessages/new.xml
  def new
    if current_user     

        @replying_to_message = Tomessage.find(:first, :conditions => "id = '#{params[:replying_to_message_id]}'")
         
        @tomessage = Tomessage.new
        @to_user = User.find(:first, :conditions => "id = '#{params[:to_id]}'")


        respond_to do |format|
          format.html # new.html.erb
          format.xml  { render :xml => @tomessage }
        end
    else
      redirect_to(server_root_url)
    end

  end

  # GET /tomessages/1/edit
  #def edit
  #  @tomessage = Tomessage.find(params[:id])
  #end

  # POST /tomessages
  # POST /tomessages.xml
  def create

    if current_user

      ### GET DATE NOW ###
      jump_forward_days = 0

      Time.zone = current_user.time_zone
      tnow = Time.zone.now
      
      #if current_user
      #  Time.zone = current_user.time_zone
      #  tnow = Time.zone.now #User time
      #else
      #  tnow = Time.now
      #end

      tnow_Y = tnow.strftime("%Y").to_i #year, 4 digits
      tnow_m = tnow.strftime("%m").to_i #month of the year
      tnow_d = tnow.strftime("%d").to_i #day of the month
      tnow_H = tnow.strftime("%H").to_i #hour (24-hour format)
      tnow_M = tnow.strftime("%M").to_i #minute of the hour
      #puts tnow_Y + tnow_m + tnow_d  
      #puts "Current timestamp is #{tnow.to_s}"
      dnow = Date.new(tnow_Y, tnow_m, tnow_d) + jump_forward_days
      ######
      
      @tomessage = Tomessage.new(params[:tomessage])

      @tomessage.to_id = params[:to_id].to_i
      @tomessage.from_id = current_user.id
      @tomessage.unread = 1
      if @tomessage.subject == ""
          @tomessage.subject = "(no subject)"
      end
      @to_user = User.find(:first, :conditions => "id = '#{@tomessage.to_id}'")

      respond_to do |format|
        if @tomessage.save

          ################
          ### START If a coach is sending an official weekly check-in message
          if params[:coachgoal_id] != nil and params[:coach_week_number] != nil
              coachgoal = Coachgoal.find(:first, :conditions => "id = '#{params[:coachgoal_id].to_i}'")
              if coachgoal != nil
                  coach_week_number = params[:coach_week_number].to_i
                  if coach_week_number == 1
                      coachgoal.week_1_email_sent_date = dnow
                  end
                  if coach_week_number == 2
                      coachgoal.week_2_email_sent_date = dnow
                  end
                  if coach_week_number == 3
                      coachgoal.week_3_email_sent_date = dnow
                  end
                  if coach_week_number == 4
                      coachgoal.week_4_email_sent_date = dnow
                  end
                  coachgoal.save
              end
          end
          ### END If a coach is sending an official weekly check-in message
          ################

          ### Notify the recipient that they have a message
          @from_user = current_user


          @from_type = "team"
          if params[:from_type]
            @from_type = params[:from_type]
          end

          @goal_id = 0
          if params[:goal_id]
            @goal_id = params[:goal_id].to_i
          end
          Notifier.deliver_tomessage_notification(@to_user, @from_user, @tomessage, @from_type, @goal_id) # sends the email

          @frommessage = Frommessage.new()
          @frommessage.to_id = @tomessage.to_id
          @frommessage.from_id = @tomessage.from_id
          @frommessage.subject = @tomessage.subject
          @frommessage.body = @tomessage.body
          @frommessage.save
          
          
          flash[:notice] = 'Message Sent.'

          if session[:show_winners_return_to_me] and session[:show_winners_return_to_me] != ""
            format.html { redirect_to(session[:show_winners_return_to_me] + "&flash=message_sent#winners") }
          else
            format.html { redirect_to("/goals?flash=message_sent") }
          end
          format.xml  { render :xml => @tomessage, :status => :created, :location => @tomessage }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @tomessage.errors, :status => :unprocessable_entity }
        end
      end

    else
      redirect_to(server_root_url)
    end
  end

  # PUT /tomessages/1
  # PUT /tomessages/1.xml
  #def update
  #  @tomessage = Tomessage.find(params[:id])
  #
  #  respond_to do |format|
  #    if @tomessage.update_attributes(params[:tomessage])
  #      flash[:notice] = 'Tomessage was successfully updated.'
  #      format.html { redirect_to(@tomessage) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @tomessage.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /tomessages/1
  # DELETE /tomessages/1.xml
  def destroy
    @tomessage = Tomessage.find(params[:id])
    @tomessage.destroy

    respond_to do |format|
      format.html { redirect_to(tomessages_url) }
      format.xml  { head :ok }
    end
  end
end
