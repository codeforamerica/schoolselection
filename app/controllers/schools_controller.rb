class SchoolsController < ApplicationController

  def index
    @geocoded_address = geocode_address(params[:address].strip) if params[:address].present?
    
    if params[:address].present? && params[:grade_level].present? && @geocoded_address.success == true && AssignmentZone.find_all_with_point(@geocoded_address.lat, @geocoded_address.lng).present?
      @walk_zone = WalkZone.find_by_name(params[:grade_level])
      @walk_zone_schools = School.walk_zone_schools(@walk_zone, @geocoded_address)
      @assignment_zones = params[:grade_level] == 'High School' ? AssignmentZone.all : AssignmentZone.find_all_with_point(@geocoded_address.lat, @geocoded_address.lng)
      @assignment_zone_schools = @assignment_zones.map {|x| x.schools_by_grade_level(params[:grade_level])}.flatten - @walk_zone_schools
      @citywide_schools = School.citywide_schools(params[:grade_level]) - @assignment_zone_schools
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
