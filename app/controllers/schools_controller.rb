class SchoolsController < ApplicationController
  layout 'application', :except => :show
  
  def index
    @grade_levels = GradeLevel.all
    address = params[:address]
    zipcode = params[:zipcode]
    grade_level = params[:grade_level]
    @address = "#{address}, #{zipcode}"
    @geocoded_address = geocode_address(@address) if params[:address].present?
    
    if address.present? && grade_level.present? && @geocoded_address.success == true && AssignmentZone.find_all_with_point(@geocoded_address.lat, @geocoded_address.lng).present?
      @grade_level = GradeLevel.find_by_number(grade_level)
      @assignment_zones = AssignmentZone.find_all_with_location_and_grade_level(@geocoded_address, @grade_level)
      @walk_zone_schools = School.walk_zone_schools(@geocoded_address, @grade_level)
      @assignment_zone_schools = School.assignment_zone_schools(@geocoded_address, @grade_level, @assignment_zones)
      @citywide_schools = School.citywide_schools(@geocoded_address, @grade_level)
      @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools).flatten.uniq
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
