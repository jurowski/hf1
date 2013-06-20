class EncourageItemsController < ApplicationController
  # GET /encourage_items
  # GET /encourage_items.xml
  def index
    @encourage_items = EncourageItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @encourage_items }
    end
  end

  # GET /encourage_items/1
  # GET /encourage_items/1.xml
  def show
    @encourage_item = EncourageItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @encourage_item }
    end
  end

  # GET /encourage_items/new
  # GET /encourage_items/new.xml
  def new
    @encourage_item = EncourageItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @encourage_item }
    end
  end

  # GET /encourage_items/1/edit
  def edit
    @encourage_item = EncourageItem.find(params[:id])
  end

  # POST /encourage_items
  # POST /encourage_items.xml
  def create
    @encourage_item = EncourageItem.new(params[:encourage_item])

    respond_to do |format|
      if @encourage_item.save
        flash[:notice] = 'EncourageItem was successfully created.'
        format.html { redirect_to(@encourage_item) }
        format.xml  { render :xml => @encourage_item, :status => :created, :location => @encourage_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @encourage_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /encourage_items/1
  # PUT /encourage_items/1.xml
  def update
    @encourage_item = EncourageItem.find(params[:id])

    respond_to do |format|
      if @encourage_item.update_attributes(params[:encourage_item])
        flash[:notice] = 'EncourageItem was successfully updated.'
        format.html { redirect_to(@encourage_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @encourage_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /encourage_items/1
  # DELETE /encourage_items/1.xml
  def destroy
    @encourage_item = EncourageItem.find(params[:id])
    @encourage_item.destroy

    respond_to do |format|
      format.html { redirect_to(encourage_items_url) }
      format.xml  { head :ok }
    end
  end
end
