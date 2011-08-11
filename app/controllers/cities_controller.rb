class CitiesController < ApplicationController
  # GET /cities
  # GET /cities.json
  def index
    @cities = City.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cities }
    end
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
    @city = City.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @city }
    end
  end

  # GET /cities/new
  # GET /cities/new.json
  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @city }
    end
  end

  # GET /cities/1/edit
  def edit
    @city = City.find(params[:id])
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render json: @city, status: :created, location: @city }
      else
        format.html { render action: "new" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.json
  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city = City.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to cities_url }
      format.json { head :ok }
    end
  end
end
