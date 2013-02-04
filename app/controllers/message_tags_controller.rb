class MessageTagsController < ApplicationController
  # GET /message_tags
  # GET /message_tags.xml
  def index
    @message_tags = MessageTag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_tags }
    end
  end

  # GET /message_tags/1
  # GET /message_tags/1.xml
  def show
    @message_tag = MessageTag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_tag }
    end
  end

  # GET /message_tags/new
  # GET /message_tags/new.xml
  def new
    @message_tag = MessageTag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_tag }
    end
  end

  # GET /message_tags/1/edit
  def edit
    @message_tag = MessageTag.find(params[:id])
  end

  # POST /message_tags
  # POST /message_tags.xml
  def create
    @message_tag = MessageTag.new(params[:message_tag])

    respond_to do |format|
      if @message_tag.save
        flash[:notice] = 'MessageTag was successfully created.'
        format.html { redirect_to(@message_tag) }
        format.xml  { render :xml => @message_tag, :status => :created, :location => @message_tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /message_tags/1
  # PUT /message_tags/1.xml
  def update
    @message_tag = MessageTag.find(params[:id])

    respond_to do |format|
      if @message_tag.update_attributes(params[:message_tag])
        flash[:notice] = 'MessageTag was successfully updated.'
        format.html { redirect_to(@message_tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /message_tags/1
  # DELETE /message_tags/1.xml
  def destroy
    @message_tag = MessageTag.find(params[:id])
    @message_tag.destroy

    respond_to do |format|
      format.html { redirect_to(message_tags_url) }
      format.xml  { head :ok }
    end
  end
end
