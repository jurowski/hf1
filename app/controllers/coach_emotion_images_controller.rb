class CoachEmotionImagesController < ApplicationController
  # GET /coach_emotion_images
  # GET /coach_emotion_images.xml
  def index
    @coach_emotion_images = CoachEmotionImage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coach_emotion_images }
    end
  end

  # GET /coach_emotion_images/1
  # GET /coach_emotion_images/1.xml
  def show
    @coach_emotion_image = CoachEmotionImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @coach_emotion_image }
    end
  end

  # GET /coach_emotion_images/new
  # GET /coach_emotion_images/new.xml
  def new
    @coach_emotion_image = CoachEmotionImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coach_emotion_image }
    end
  end

  # GET /coach_emotion_images/1/edit
  def edit
    @coach_emotion_image = CoachEmotionImage.find(params[:id])
  end

  # POST /coach_emotion_images
  # POST /coach_emotion_images.xml
  def create
    @coach_emotion_image = CoachEmotionImage.new(params[:coach_emotion_image])

    respond_to do |format|
      if @coach_emotion_image.save
        flash[:notice] = 'CoachEmotionImage was successfully created.'
        format.html { redirect_to(@coach_emotion_image) }
        format.xml  { render :xml => @coach_emotion_image, :status => :created, :location => @coach_emotion_image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coach_emotion_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /coach_emotion_images/1
  # PUT /coach_emotion_images/1.xml
  def update
    @coach_emotion_image = CoachEmotionImage.find(params[:id])

    respond_to do |format|
      if @coach_emotion_image.update_attributes(params[:coach_emotion_image])
        flash[:notice] = 'CoachEmotionImage was successfully updated.'
        format.html { redirect_to(@coach_emotion_image) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @coach_emotion_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /coach_emotion_images/1
  # DELETE /coach_emotion_images/1.xml
  def destroy
    @coach_emotion_image = CoachEmotionImage.find(params[:id])
    @coach_emotion_image.destroy

    respond_to do |format|
      format.html { redirect_to(coach_emotion_images_url) }
      format.xml  { head :ok }
    end
  end
end
