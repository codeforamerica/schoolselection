class SchoolsController < ApplicationController

  def index
    address = params[:address]
    grade_level = params[:grade_level]
    @geocoded_address = geocode_address(address.strip) if address.present?
    
    if address.present? && grade_level.present? && @geocoded_address.success == true && AssignmentZone.find_all_with_point(@geocoded_address.lat, @geocoded_address.lng).present?
      @walk_zone = WalkZone.find_by_name(grade_level)
      @assignment_zones = AssignmentZone.assignment_zones_by_grade_level(grade_level, @geocoded_address)
      @walk_zone_schools = School.walk_zone_schools(@geocoded_address, @walk_zone)
      @assignment_zone_schools = School.assignment_zone_schools(@geocoded_address, @walk_zone, @assignment_zones)
      @citywide_schools = School.citywide_schools(@geocoded_address, @walk_zone)
    else
      @assignment_zones = AssignmentZone.all
      @map_center = Geokit::Geocoders::GoogleGeocoder.geocode('Roxbury, Boston, MA')
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
end
