class WalkZonesController < ApplicationController
  # GET /walk_zones
  # GET /walk_zones.json
  def index
    @walk_zones = WalkZone.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @walk_zones }
    end
  end

  # GET /walk_zones/1
  # GET /walk_zones/1.json
  def show
    @walk_zone = WalkZone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @walk_zone }
    end
  end

  # GET /walk_zones/new
  # GET /walk_zones/new.json
  def new
    @walk_zone = WalkZone.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @walk_zone }
    end
  end

  # GET /walk_zones/1/edit
  def edit
    @walk_zone = WalkZone.find(params[:id])
  end

  # POST /walk_zones
  # POST /walk_zones.json
  def create
    @walk_zone = WalkZone.new(params[:walk_zone])

    respond_to do |format|
      if @walk_zone.save
        format.html { redirect_to @walk_zone, notice: 'Walk zone was successfully created.' }
        format.json { render json: @walk_zone, status: :created, location: @walk_zone }
      else
        format.html { render action: "new" }
        format.json { render json: @walk_zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /walk_zones/1
  # PUT /walk_zones/1.json
  def update
    @walk_zone = WalkZone.find(params[:id])

    respond_to do |format|
      if @walk_zone.update_attributes(params[:walk_zone])
        format.html { redirect_to @walk_zone, notice: 'Walk zone was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @walk_zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /walk_zones/1
  # DELETE /walk_zones/1.json
  def destroy
    @walk_zone = WalkZone.find(params[:id])
    @walk_zone.destroy

    respond_to do |format|
      format.html { redirect_to walk_zones_url }
      format.json { head :ok }
    end
  end
end
