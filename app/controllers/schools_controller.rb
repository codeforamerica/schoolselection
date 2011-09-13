class SchoolsController < ApplicationController
  layout 'application', :except => :show
  
  def index
    @grade_levels = GradeLevel.all
    address = params[:address]
    zipcode = params[:zipcode]
    grade_level = params[:grade_level]
    @address = "#{address}, #{zipcode}"
    @geocoded_address = geocode_address(@address) if params[:address].present?
    
    if address.present? && grade_level.present? && @geocoded_address.success == true && AssignmentZone.find_by_location(@geocoded_address).present?
      @grade_level = GradeLevel.find_by_number(grade_level)
      @assignment_zone = AssignmentZone.find_by_location(@geocoded_address).first
      
      @walk_zone_schools = @grade_level.schools.find_all_within_radius(@geocoded_address, @grade_level.walk_zone_radius)
      @assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone) - @walk_zone_schools
      @citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide) - @walk_zone_schools
      
      @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)
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
