class MessageMotivationsController < ApplicationController
  # GET /message_motivations
  # GET /message_motivations.xml
  def index
    @message_motivations = MessageMotivation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_motivations }
    end
  end

  # GET /message_motivations/1
  # GET /message_motivations/1.xml
  def show
    @message_motivation = MessageMotivation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_motivation }
    end
  end

  # GET /message_motivations/new
  # GET /message_motivations/new.xml
  def new
    @message_motivation = MessageMotivation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_motivation }
    end
  end

  # GET /message_motivations/1/edit
  def edit
    @message_motivation = MessageMotivation.find(params[:id])
  end

  # POST /message_motivations
  # POST /message_motivations.xml
  def create
    @message_motivation = MessageMotivation.new(params[:message_motivation])

    respond_to do |format|
      if @message_motivation.save
        flash[:notice] = 'MessageMotivation was successfully created.'
        format.html { redirect_to(@message_motivation) }
        format.xml  { render :xml => @message_motivation, :status => :created, :location => @message_motivation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_motivation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /message_motivations/1
  # PUT /message_motivations/1.xml
  def update
    @message_motivation = MessageMotivation.find(params[:id])

    respond_to do |format|
      if @message_motivation.update_attributes(params[:message_motivation])
        flash[:notice] = 'MessageMotivation was successfully updated.'
        format.html { redirect_to(@message_motivation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_motivation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /message_motivations/1
  # DELETE /message_motivations/1.xml
  def destroy
    @message_motivation = MessageMotivation.find(params[:id])
    @message_motivation.destroy

    respond_to do |format|
      format.html { redirect_to(message_motivations_url) }
      format.xml  { head :ok }
    end
  end
end
