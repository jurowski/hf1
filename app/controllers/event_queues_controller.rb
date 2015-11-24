class EventQueuesController < ApplicationController
  # GET /event_queues
  # GET /event_queues.xml
  def index
    @event_queues = EventQueue.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event_queues }
    end
  end

  # GET /event_queues/1
  # GET /event_queues/1.xml
  def show
    @event_queue = EventQueue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event_queue }
    end
  end

  # GET /event_queues/new
  # GET /event_queues/new.xml
  def new
    @event_queue = EventQueue.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event_queue }
    end
  end

  # GET /event_queues/1/edit
  def edit
    @event_queue = EventQueue.find(params[:id])
  end

  # POST /event_queues
  # POST /event_queues.xml
  def create
    @event_queue = EventQueue.new(params[:event_queue])

    respond_to do |format|
      if @event_queue.save
        flash[:notice] = 'EventQueue was successfully created.'
        format.html { redirect_to(@event_queue) }
        format.xml  { render :xml => @event_queue, :status => :created, :location => @event_queue }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event_queue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /event_queues/1
  # PUT /event_queues/1.xml
  def update
    @event_queue = EventQueue.find(params[:id])

    respond_to do |format|
      if @event_queue.update_attributes(params[:event_queue])
        flash[:notice] = 'EventQueue was successfully updated.'
        format.html { redirect_to(@event_queue) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event_queue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event_queues/1
  # DELETE /event_queues/1.xml
  def destroy
    @event_queue = EventQueue.find(params[:id])
    @event_queue.destroy

    respond_to do |format|
      format.html { redirect_to(event_queues_url) }
      format.xml  { head :ok }
    end
  end
end
