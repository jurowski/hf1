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
    respond_to do |format|
      format.html
    end
  end

end
