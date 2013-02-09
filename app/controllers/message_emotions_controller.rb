class MessageEmotionsController < ApplicationController
  # GET /message_emotions
  # GET /message_emotions.xml
  def index
    @message_emotions = MessageEmotion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_emotions }
    end
  end

  # GET /message_emotions/1
  # GET /message_emotions/1.xml
  def show
    @message_emotion = MessageEmotion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_emotion }
    end
  end

  # GET /message_emotions/new
  # GET /message_emotions/new.xml
  def new
    @message_emotion = MessageEmotion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_emotion }
    end
  end

  # GET /message_emotions/1/edit
  def edit
    @message_emotion = MessageEmotion.find(params[:id])
  end

  # POST /message_emotions
  # POST /message_emotions.xml
  def create
    @message_emotion = MessageEmotion.new(params[:message_emotion])

    respond_to do |format|
      if @message_emotion.save
        flash[:notice] = 'MessageEmotion was successfully created.'
        format.html { redirect_to(@message_emotion) }
        format.xml  { render :xml => @message_emotion, :status => :created, :location => @message_emotion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_emotion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /message_emotions/1
  # PUT /message_emotions/1.xml
  def update
    @message_emotion = MessageEmotion.find(params[:id])

    respond_to do |format|
      if @message_emotion.update_attributes(params[:message_emotion])
        flash[:notice] = 'MessageEmotion was successfully updated.'
        format.html { redirect_to(@message_emotion) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_emotion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /message_emotions/1
  # DELETE /message_emotions/1.xml
  def destroy
    @message_emotion = MessageEmotion.find(params[:id])
    @message_emotion.destroy

    respond_to do |format|
      format.html { redirect_to(message_emotions_url) }
      format.xml  { head :ok }
    end
  end
end
