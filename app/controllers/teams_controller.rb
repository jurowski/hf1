class TeamsController < ApplicationController

  require 'date'
  require 'logger'

  ### for gravatar
  ### http://stackoverflow.com/questions/5822912/how-do-i-display-an-avatar-in-rails
  require 'digest/md5'

  layout "application"

  before_filter :require_user
  before_filter :require_admin_user, :only => [:index]
  before_filter :require_owner_team, :except => [:new, :create]

  def require_owner_team
    if params[:id]

      team = Team.find(params[:id].to_i)
      if team
        unless (team.i_am_owner_or_admin(current_user.id))
          flash[:notice] = "You do not have rights to access that page."
          redirect_to "/"
          return false
        end
      end

    end

  end



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


    @team.qty_max = 4

    template_goal_id = 0
    found_template_goal = false

    if params[:goal_id]
      @goal = Goal.find(params[:goal_id].to_i)
    end

    if @goal
      @team.category_name = @goal.category if @goal.category
    end

    @example_team_name = current_user.first_name + "'s " + @goal.category + " Team"

    if params[:team_type] and @goal

      @team.custom = true
      @team.invite_only = true
      @team.owner_user_id = @goal.user.id

      @team.invitation_subject = "Come join my team!"

      @team.invitation_body = "Hello... this is " + current_user.first_name + ", and I'm using the HabitForge"
      @team.invitation_body += " web application. 

I've started a brand new team "

      if params[:team_type] == "category"
       ### do nothing special ... we've already grabbed the category and will simply not set goal_template_parent_id
       @team.invitation_body += "for those who want to work on establishing a new habit in the " + @goal.category + " category."
      end

      if params[:team_type] == "goal"
          begin
              ### if the goal does not yet have a template_goal_id
              if !@goal.template_user_parent_goal_id

                ### if not Success copying the goal to a new template and assigning the template as the parent                
                if @goal.copy_goal_to_template_and_make_template_parent
                  logger.info("sgj:teams_controller:successfully ran @goal.copy_goal_to_template_and_make_template_parent on goal id " + @goal.id.to_s)
                else                  
                  logger.error("sgj:teams_controller:error while trying to run @goal.copy_goal_to_template_and_make_template_parent on goal id " + @goal.id.to_s)
                end              
              end ### end if @goal.template_user_parent_goal_id

              @template_goal = Goal.find(@goal.template_user_parent_goal_id)

              found_template_goal = true
          rescue
            ### could not find goal in question
            logger.error("sgj:teams_controller:error in making or determining parent template")
          end

          if found_template_goal
            @team.goal_template_parent_id = @template_goal.id
            @team.invitation_body += "for those who want to work on establishing a new habit of " + @goal.title + "."
          end
      end ### if params[:team_type] == "goal"


      @team.invitation_body += " 

I'd love for you to join my team!

You'd just need to create a free account on the HabitForge site ( http://habitforge.com ) and register with your email address (you'd want to register with the same email address I just reached you at so my goal is linked to your account). 

Let's do this together! It'll be fun and rewarding, and as a team encouraging one another with some positive pressure, we can accomplish a lot more than we could on our own!

"
      @team.invitation_body += "--" + current_user.first_name

    end ### if params[:team_type] and @goal



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
    @team.qty_current = 0

    respond_to do |format|
      if @team.save

        #### if this team was being created by an end user 
        #### from a goal, save the goal to be part of this new team
        begin
          if params[:goal_id]
            goal = Goal.find(params[:goal_id].to_i)
            goal.team_id = @team.id
            goal.save

            @team.qty_current += 1
            @team.save
            
          end
        rescue
          logger.debug("sgj:teams_controller:create:error while saving team_id to goal")
        end

        ### calculate openings and then save
        @team.calc_has_openings_save

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
      format.html { redirect_to("/goals") }
      format.xml  { head :ok }
    end
  end
end
