class SchoolsController < ApplicationController
  # GET /schools
  # GET /schools.json
  def index
    if params[:address].present? && params[:grade_level].present?
      boston_bounds = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA').suggested_bounds
      @location = Geokit::Geocoders::GoogleGeocoder.geocode(params[:address], :bias => boston_bounds)
      @walk_zone = WalkZone.find_by_name(params[:grade_level])
      @walk_zone_schools = School.find(:all, :origin => @location, :within => @walk_zone.distance, :order => 'distance').select {|school| school.walk_zones.include?(@walk_zone) }
      @schools = (School.school_level_finder(params[:grade_level]) - @walk_zone_schools).sort_by {|x| x.name}
    elsif params[:grade_level].present?
      @schools = School.school_level_finder(params[:grade_level])
    else
      @schools = School.all(:order => :name)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schools }
    end
  end

  # GET /schools/1
  # GET /schools/1.json
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
