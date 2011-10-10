class SchoolsController < ApplicationController
  layout 'application', :except => :show
  
  def index
    @grade_levels = GradeLevel.all
    address, session[:address] = params[:address], params[:address]
    zipcode, session[:zipcode] = params[:zipcode], params[:zipcode]
    grade_level, session[:grade_level] = params[:grade_level], params[:grade_level]
    @address = "#{address}, #{zipcode}"
    @geocoded_address = geocode_address(@address) if address.present?    
    @vertex = Vertex.nearest_to(@geocoded_address).first
    if address.present? && grade_level.present? && @geocoded_address.success == true && AssignmentZone.find_by_location(@geocoded_address).present?
      shared_instance_variables
    else
      @assignment_zones = AssignmentZone.all
    end
    respond_to do |format|
      format.html
      format.js 
    end
  end

  def show
    @favorite_schools = session[:favorites]
    @school = School.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school }
    end
  end
  
  ####### AJAX #######
  
  def switch_tab
    respond_to do |format|
      format.js
    end
  end
  
  def favorite
    @geocoded_address = geocode_address(session[:address])
    shared_instance_variables
    @school = @all_schools.find {|x| x.id == params[:id].to_i}
    session[:favorites] ||= []
    session[:favorites] << @school.id unless session[:favorites].include?(@school.id)
    respond_to do |format|
      format.js
    end
  end
  
  def unfavorite
    @geocoded_address = geocode_address(session[:address])
    shared_instance_variables
    @school = @all_schools.find {|x| x.id == params[:id].to_i}
    session[:favorites].delete_if {|x| x == @school.id }
    respond_to do |format|
      format.js
    end
  end
  
  def hide
    @school = School.find(params[:id])
    session[:favorites].delete_if {|x| x == @school.id } if session[:favorites].present?
    session[:hidden] ||= []
    session[:hidden] << @school.id unless session[:hidden].include?(@school.id)
    respond_to do |format|
      format.js
    end
  end
  
  def unhide
    @geocoded_address = geocode_address(session[:address])
    shared_instance_variables
    @school = @all_schools.find {|x| x.id == params[:id].to_i}
    session[:hidden] ||= []
    session[:hidden].delete_if {|x| x == @school.id }
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def shared_instance_variables
    session[:favorites].present? ? @favorite_schools = School.find(session[:favorites]) : @favorite_schools = []
    session[:hidden].present? ? @hidden_schools = School.find(session[:hidden]) : @hidden_schools = []
    @grade_level = GradeLevel.find_by_number(session[:grade_level])
    @assignment_zone = AssignmentZone.find_by_location(@geocoded_address).first
    @walkshed = walkshed_for_point(@vertex,@grade_level.walk_zone_radius_in_meters / 1000.0)
    @walkshed_polygon = ::RGeo::WKRep::WKBParser.new(RGeo::Geographic.spherical_factory).parse_hex(@walkshed)
    
    @walk_zone_schools = @grade_level.schools.within_walkshed(@walkshed).with_walking_distance(@vertex)
    ids = @walk_zone_schools.map(&:id)
    @assignment_zone_schools = @grade_level.schools.where("id not in (?)",ids).where(:assignment_zone_id => @assignment_zone)
    @citywide_schools = @grade_level.schools.where("id not in (?)",ids).where(:assignment_zone_id => AssignmentZone.citywide)
    @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)

    distances = driving_distances_for_point(@vertex)
    @all_schools.each {|s| s.driving_distance = distances[s.vertex_id]}
    @all_schools.sort_by! {|x| x.driving_distance || 1000}
    
    @visible_schools = (@all_schools - @hidden_schools)
    [ [@walk_zone_schools,"Walk Zone",1], [@assignment_zone_schools,"Assignment Zone",2], [@citywide_schools,"Citywide",3] ].each do |schools,type,index|
      schools.each do |s|
        s.eligibility = type
        s.eligibility_index = index
      end
    end
    if params[:sibling_school] && (sib_school = @all_schools.find {|s| s.id == params[:sibling_school].to_i})
      #raise "in here"
      sib_school.eligibility = "Sibling School / "+sib_school.eligibility
      sib_school.eligibility_index = 0
    end
  end
end
