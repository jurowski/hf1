class QuantsController < ApplicationController
  require 'date'
  require 'logger'

  ### for URL encoding/decoding
  ### http://stackoverflow.com/questions/17223808/converting-url-encoded-strings-into-plain-text-with-ruby
  require 'cgi'

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  #include GoalsHelper
  #include CoachgoalsHelper

  layout "application"



  before_filter :require_user
  #before_filter :require_user, :only => [:single, :show, :new, :edit, :destroy, :update, :invite_a_friend_to_track]
  #before_filter :require_user_unless_newly_paid, :only => [:index]


  before_filter :require_owner, :except => [:new, :create]

  def require_owner
    if params[:id]

      quant = Quant.find(params[:id].to_i)
      if quant
        unless (quant.i_am_owner_or_admin(current_user.id))
          flash[:notice] = "You do not have rights to access that page."
          redirect_to "/"
          return false
        end
      end

    end

  end


  def get_dnow
    ### GET DATE NOW ###
    jump_forward_days = 0

    Time.zone = @tracker.user.time_zone
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
    return dnow
  end
  



  ### http://stackoverflow.com/questions/10539143/reloading-partial-in-an-rails-app
  # GET /quants/goal_quants_manage
  def goal_quants_manage

    @goal = Goal.new()
    if params[:goal_id]
        @goal = Goal.find(params[:goal_id].to_i)
        quant = Quant.new()
        quant.goal_id = @goal.id
        quant.user_id = @goal.user.id
        #quant.measurement = params[:quant_value].to_i

        logger.debug("sgj:quants_controller:quant_value = " + params[:quant_value]) ### does show decimals



        ## http://stackoverflow.com/questions/3063968/string-decimal-or-float-datatype-for-price-field
        ## but integers has no 13.25?
        ## That is why you base it on cents. So the $13.25 gets stored as 1325 in the database. You format the dollar sign and the decimal in the view.
        ### so for HF tracking, when you display this, divide it by 100 ... this is how you represent decimal values with an int
        quant.measurement = (params[:quant_value].to_f + 0.00) * 100 



        quant.measurement_taken_timestamp = @goal.user.timestamp_now
        quant.measurement_date = @goal.user.dtoday
        quant.measurement_hour = @goal.user.time_hour_right_now

        if params[:quant_datetime] and params[:quant_datetime].size > 0

          ### decode the URL as per:
          ### http://stackoverflow.com/questions/17223808/converting-url-encoded-strings-into-plain-text-with-ruby
          quant_datetime = CGI::unescape(params[:quant_datetime])

          arr_datetime_split = quant_datetime.split(" ")
          the_month = Date::MONTHNAMES.index(arr_datetime_split[1])
          #the_month = 1
          the_year = arr_datetime_split[2]
          the_day = arr_datetime_split[0]
          the_hour = arr_datetime_split[4]
          logger.debug("sgj:quants_controller:datetime after splitting = " + the_month.to_s + "/" + the_day.to_s + "/" + the_year.to_s + " @ " + the_hour.to_s)

          quant.measurement_date = the_year.to_s + "-" + the_month.to_s + "-" + the_day.to_s
          quant.measurement_hour = the_hour
        end


        logger.debug("sgj:quants_controller:timestamp = " + quant.measurement_taken_timestamp.to_s)
        logger.debug("sgj:quants_controller:date form element = " + params[:quant_datetime].to_s)

        quant.save

    end


    render :partial => "quants/goal_quants_manage", :locals => { :goal => @goal } 
  end








  # GET /quants
  # GET /quants.xml
  def index
    @quants = Quant.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quants }
    end
  end

  # GET /quants/1
  # GET /quants/1.xml
  def show
    @quant = Quant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quant }
    end
  end

  # GET /quants/new
  # GET /quants/new.xml
  def new
    @quant = Quant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quant }
    end
  end

  # GET /quants/1/edit
  def edit
    @quant = Quant.find(params[:id])
  end

  # POST /quants
  # POST /quants.xml
  def create
    @quant = Quant.new(params[:quant])

    respond_to do |format|
      if @quant.save
        flash[:notice] = 'Quant was successfully created.'
        format.html { redirect_to(@quant) }
        format.xml  { render :xml => @quant, :status => :created, :location => @quant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quants/1
  # PUT /quants/1.xml
  def update
    @quant = Quant.find(params[:id])

    respond_to do |format|
      if @quant.update_attributes(params[:quant])
        flash[:notice] = 'Quant was successfully updated.'
        format.html { redirect_to(@quant) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quants/1
  # DELETE /quants/1.xml
  def destroy
    @quant = Quant.find(params[:id])
    goal_id = @quant.goal.id
    @quant.destroy

    respond_to do |format|
      format.html { redirect_to('/goals#tab_1_5_' + goal_id.to_s) }
      format.xml  { head :ok }
    end
  end
end
