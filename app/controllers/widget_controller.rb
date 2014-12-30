class WidgetController < ApplicationController
  def start
    respond_to do |format|
      format.html # start.html.erb
    end
  end

  def start_any
    respond_to do |format|
      format.html # start_any.html.erb
    end
  end

  def start_levin
    respond_to do |format|
      format.html # start_levin.html.erb
    end
  end

  def start_princeton_club
	respond_to do |format|
	  format.html # start_princeton_club.html.erb
	end
  end

  def startlarge
    respond_to do |format|
      format.html # startlarge.html.erb
    end
  end

  def upgrade
    if current_user
      logger.info "sgj:widget_controller:just displaying paywhirl upgrade page user_id=#{current_user.id}"
    else
      logger.info "sgj:widget_controller:just displaying paywhirl upgrade page BUT USER NOT LOGGED IN"
    end

    respond_to do |format|
      format.html
    end
  end

  def upgrade_held_to_it
    if current_user
      logger.info "sgj:widget_controller:just displaying paywhirl upgrade HELD_TO_IT page user_id=#{current_user.id}"
    else
      logger.info "sgj:widget_controller:just displaying paywhirl upgrade HELD_TO_IT page BUT USER NOT LOGGED IN"
    end

    respond_to do |format|
      format.html
    end
  end

  def newsletter
    if current_user
      logger.info "sgj:widget_controller:just displaying newsletter page user_id=#{current_user.id}"
    else
      logger.info "sgj:widget_controller:just displaying newsletter page BUT USER NOT LOGGED IN"
    end

    respond_to do |format|
      format.html
    end
  end

end
