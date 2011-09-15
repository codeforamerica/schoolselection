class NeighborhoodsController < ApplicationController
  # GET /neighborhoods
  # GET /neighborhoods.json
  def index
    @neighborhoods = Neighborhood.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @neighborhoods }
    end
  end

  # GET /neighborhoods/1
  # GET /neighborhoods/1.json
  def show
    @neighborhood = Neighborhood.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @neighborhood }
    end
  end

  # GET /neighborhoods/new
  # GET /neighborhoods/new.json
  def new
    @neighborhood = Neighborhood.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @neighborhood }
    end
  end

  # GET /neighborhoods/1/edit
  def edit
    @neighborhood = Neighborhood.find(params[:id])
  end

  # POST /neighborhoods
  # POST /neighborhoods.json
  def create
    @neighborhood = Neighborhood.new(params[:neighborhood])

    respond_to do |format|
      if @neighborhood.save
        format.html { redirect_to @neighborhood, notice: 'Neighborhood was successfully created.' }
        format.json { render json: @neighborhood, status: :created, location: @neighborhood }
      else
        format.html { render action: "new" }
        format.json { render json: @neighborhood.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /neighborhoods/1
  # PUT /neighborhoods/1.json
  def update
    @neighborhood = Neighborhood.find(params[:id])

    respond_to do |format|
      if @neighborhood.update_attributes(params[:neighborhood])
        format.html { redirect_to @neighborhood, notice: 'Neighborhood was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @neighborhood.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /neighborhoods/1
  # DELETE /neighborhoods/1.json
  def destroy
    @neighborhood = Neighborhood.find(params[:id])
    @neighborhood.destroy

    respond_to do |format|
      format.html { redirect_to neighborhoods_url }
      format.json { head :ok }
    end
  end
end
