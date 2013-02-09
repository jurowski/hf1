class CounterImagesSetsController < ApplicationController
  # GET /counter_images_sets
  # GET /counter_images_sets.xml
  def index
    @counter_images_sets = CounterImagesSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @counter_images_sets }
    end
  end

  # GET /counter_images_sets/1
  # GET /counter_images_sets/1.xml
  def show
    @counter_images_set = CounterImagesSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @counter_images_set }
    end
  end

  # GET /counter_images_sets/new
  # GET /counter_images_sets/new.xml
  def new
    @counter_images_set = CounterImagesSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @counter_images_set }
    end
  end

  # GET /counter_images_sets/1/edit
  def edit
    @counter_images_set = CounterImagesSet.find(params[:id])
  end

  # POST /counter_images_sets
  # POST /counter_images_sets.xml
  def create
    @counter_images_set = CounterImagesSet.new(params[:counter_images_set])

    respond_to do |format|
      if @counter_images_set.save
        flash[:notice] = 'CounterImagesSet was successfully created.'
        format.html { redirect_to(@counter_images_set) }
        format.xml  { render :xml => @counter_images_set, :status => :created, :location => @counter_images_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @counter_images_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /counter_images_sets/1
  # PUT /counter_images_sets/1.xml
  def update
    @counter_images_set = CounterImagesSet.find(params[:id])

    respond_to do |format|
      if @counter_images_set.update_attributes(params[:counter_images_set])
        flash[:notice] = 'CounterImagesSet was successfully updated.'
        format.html { redirect_to(@counter_images_set) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @counter_images_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /counter_images_sets/1
  # DELETE /counter_images_sets/1.xml
  def destroy
    @counter_images_set = CounterImagesSet.find(params[:id])
    @counter_images_set.destroy

    respond_to do |format|
      format.html { redirect_to(counter_images_sets_url) }
      format.xml  { head :ok }
    end
  end
end
