class SchoolsController < ApplicationController

  def index
    @geocoded_address = geocode_address(params[:address].strip) if params[:address].present?
    
    if params[:address].present? && params[:grade_level].present? && @geocoded_address.success == true && AssignmentZone.find_with_point(@geocoded_address.lat, @geocoded_address.lng).present?
      @walk_zone = WalkZone.find_by_name(params[:grade_level])
      @walk_zone_schools = School.find(:all, :origin => @geocoded_address, :within => @walk_zone.distance, :order => 'distance', :conditions => ['school_level_id IN (?)', @walk_zone.school_levels])
      @assignment_zones = AssignmentZone.find_with_point(@geocoded_address.lat, @geocoded_address.lng)
      @assignment_zone_schools = @assignment_zones.map {|x| x.schools(params[:grade_level])}.flatten - @walk_zone_schools
      
      @assignment_zone_json = "[#{@assignment_zones.map {|x| x.geokitted_coordinates.to_json}[0]}]"
      @markers_json = (@walk_zone_schools + @assignment_zone_schools.flatten).to_gmaps4rails
      @walk_zone_json = "[{'lng': #{@geocoded_address.lng}, 'lat': #{@geocoded_address.lat}, 'radius': #{@walk_zone.distance * 1609.344}, 'fillColor': '#33cc00', 'fillOpacity': 0.35, 'strokeColor': '#000000', 'strokeOpacity': 0.6, 'strokeWeight': 1.5}]"
    else
      @location = Geokit::Geocoders::GoogleGeocoder.geocode('Roxbury, Boston, MA')
      @schools = School.school_level_finder(params[:grade_level])
      @markers = @schools.to_gmaps4rails
      @assignment_zones_json = "[#{AssignmentZone.find(1).geokitted_coordinates.to_json}, #{AssignmentZone.find(2).geokitted_coordinates.to_json}, #{AssignmentZone.find(3).geokitted_coordinates.to_json}]"
    end

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
