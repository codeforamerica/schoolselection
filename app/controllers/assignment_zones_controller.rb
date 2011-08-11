class AssignmentZonesController < ApplicationController
  # GET /assignment_zones
  # GET /assignment_zones.json
  def index
    @assignment_zones = AssignmentZone.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assignment_zones }
    end
  end

  # GET /assignment_zones/1
  # GET /assignment_zones/1.json
  def show
    @assignment_zone = AssignmentZone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assignment_zone }
    end
  end

  # GET /assignment_zones/new
  # GET /assignment_zones/new.json
  def new
    @assignment_zone = AssignmentZone.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assignment_zone }
    end
  end

  # GET /assignment_zones/1/edit
  def edit
    @assignment_zone = AssignmentZone.find(params[:id])
  end

  # POST /assignment_zones
  # POST /assignment_zones.json
  def create
    @assignment_zone = AssignmentZone.new(params[:assignment_zone])

    respond_to do |format|
      if @assignment_zone.save
        format.html { redirect_to @assignment_zone, notice: 'Assignment zone was successfully created.' }
        format.json { render json: @assignment_zone, status: :created, location: @assignment_zone }
      else
        format.html { render action: "new" }
        format.json { render json: @assignment_zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assignment_zones/1
  # PUT /assignment_zones/1.json
  def update
    @assignment_zone = AssignmentZone.find(params[:id])

    respond_to do |format|
      if @assignment_zone.update_attributes(params[:assignment_zone])
        format.html { redirect_to @assignment_zone, notice: 'Assignment zone was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @assignment_zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignment_zones/1
  # DELETE /assignment_zones/1.json
  def destroy
    @assignment_zone = AssignmentZone.find(params[:id])
    @assignment_zone.destroy

    respond_to do |format|
      format.html { redirect_to assignment_zones_url }
      format.json { head :ok }
    end
  end
end
