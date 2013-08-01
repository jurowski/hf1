class TeamsController < ApplicationController

  require 'date'
  require 'logger'

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  layout "application"

  before_filter :require_user
  before_filter :require_admin_user, :except => [:new, :create]

  # GET /teams
  # GET /teams.xml
  def index
    @teams = Team.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @team = Team.new

    if params[:team_type]
      if params[:team_type] == "category" and params[:category_name]
        @team.category_name = params[:category_name]
      end

      if params[:team_type] == "goal" and params[:goal_id]

          begin
            goal = Goal.find(params[:goal_id].to_i)
            if goal

              ### if the goal already has a template_goal_id, great 
              ### if the goal does not yet have a template_goal_id
              ###   duplicate the goal into a template
              ###     in the goal.rb model, make a function to copy a goal to a template
              ###     see goals_controller.rb:create for which fields to copy:
              ###       user_id title response_question 
              ###       start(1900-01-01) stop(1900-01-01) established_on(1900-01-01)
              ###       category publish(0) share(0) status(hold)
              ###       gmt_offset serversendhour usersendhour daym dayt dayw dayr dayf days dayn
              ###       goal_days_per_week reminder_send_hour 
              ###       more_reminders_enabled more_reminders_start more_reminders_end
              ###       more_reminders_every_n_hours more_reminders_last_sent
              ###       allow_push pushes_allowed_per_day team_summary_send_hour 
              ###       check_in_same_day set:template_owner_is_a_template(1) 

              ###     assign the template_goal_id to the goal

              ### assign the template_goal_id to this team
            end
          rescue
            ### could not find goal in question
          end


      end

    end



    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.xml
  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to(@team) }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to(@team) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(teams_url) }
      format.xml  { head :ok }
    end
  end
end
