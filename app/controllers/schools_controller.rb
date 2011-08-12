class SchoolsController < ApplicationController

  def index
    if params[:address].present? && params[:grade_level].present?
      @location = Geokit::Geocoders::GoogleGeocoder.geocode(params[:address], :bias => BOSTON_BOUNDS)
      walk_zone = WalkZone.find_by_name(params[:grade_level])
      @walk_zone_schools = School.find(:all, :origin => @location, :within => walk_zone.distance, :order => 'distance', :conditions => ['school_level_id IN (?)', walk_zone.school_levels])
      @schools = (School.school_level_finder(params[:grade_level]) - @walk_zone_schools).sort_by {|x| x.name}
      @markers = (@walk_zone_schools + @schools).to_gmaps4rails
      @circle = "[{'lng': #{@location.lng}, 'lat': #{@location.lat}, 'radius': #{walk_zone.distance * 1609.344}, 'strokeColor': '#33cc00', 'strokeOpacity': 0.035, 'fillColor': '#33cc00', 'fillOpacity': 0.35}]"
    else
      @location = BOSTON
      @schools = School.school_level_finder(params[:grade_level])
      @markers = @schools.to_gmaps4rails
    end
    @latitude = @location.lat
    @longitude = @location.lng

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schools }
    end
  end

  def show
    @school = School.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school }
    end
  end

  # GET /schools/new
  # GET /schools/new.json
  def new
    @school = School.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @school }
    end
  end

  # GET /schools/1/edit
  def edit
    @school = School.find(params[:id])
  end

  # POST /schools
  # POST /schools.json
  def create
    @school = School.new(params[:school])

    respond_to do |format|
      if @school.save
        format.html { redirect_to @school, notice: 'School was successfully created.' }
        format.json { render json: @school, status: :created, location: @school }
      else
        format.html { render action: "new" }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /schools/1
  # PUT /schools/1.json
  def update
    @school = School.find(params[:id])

    respond_to do |format|
      if @school.update_attributes(params[:school])
        format.html { redirect_to @school, notice: 'School was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.json
  def destroy
    @school = School.find(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_to schools_url }
      format.json { head :ok }
    end
  end
end
