class CounterImagesController < ApplicationController
  # GET /counter_images
  # GET /counter_images.xml
  def index
    @counter_images = CounterImage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @counter_images }
    end
  end

  # GET /counter_images/1
  # GET /counter_images/1.xml
  def show
    @counter_image = CounterImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @counter_image }
    end
  end

  # GET /counter_images/new
  # GET /counter_images/new.xml
  def new
    @counter_image = CounterImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @counter_image }
    end
  end

  # GET /counter_images/1/edit
  def edit
    @counter_image = CounterImage.find(params[:id])
  end

  # POST /counter_images
  # POST /counter_images.xml
  def create
    @counter_image = CounterImage.new(params[:counter_image])

    respond_to do |format|
      if @counter_image.save
        flash[:notice] = 'CounterImage was successfully created.'
        format.html { redirect_to(@counter_image) }
        format.xml  { render :xml => @counter_image, :status => :created, :location => @counter_image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @counter_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /counter_images/1
  # PUT /counter_images/1.xml
  def update
    @counter_image = CounterImage.find(params[:id])

    respond_to do |format|
      if @counter_image.update_attributes(params[:counter_image])
        flash[:notice] = 'CounterImage was successfully updated.'
        format.html { redirect_to(@counter_image) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @counter_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /counter_images/1
  # DELETE /counter_images/1.xml
  def destroy
    @counter_image = CounterImage.find(params[:id])
    @counter_image.destroy

    respond_to do |format|
      format.html { redirect_to(counter_images_url) }
      format.xml  { head :ok }
    end
  end
end
