class SchoolsController < ApplicationController
  # layout 'application', :except => :show
  
  def index
    address, session[:address] = params[:address], params[:address]
    zipcode, session[:zipcode] = params[:zipcode], params[:zipcode]
    grade_level, session[:grade_level] = params[:grade_level], params[:grade_level]
    session[:favorites].present? ? @favorite_schools = session[:favorites].map {|x| School.find(x)} : @favorite_schools = []
    address.present? ? @geocoded_address = geocode_address("#{address}, #{zipcode}") : @geocoded_address = geocode_address('26 Court Street, Boston, MA 02109')
    
    if address.present? && grade_level.present? && @geocoded_address.success == true && AssignmentZone.find_by_location(@geocoded_address).present?
      shared_variables
    else
      @all_schools = School.all
    end
    respond_to do |format|
      format.html
      format.js 
    end
  end

  def show
    shared_variables
    session[:favorites].present? ? @favorite_schools = session[:favorites].map {|x| School.find(x)} : @favorite_schools = []
    @school = @all_schools.find {|x| x.id == params[:id].to_i }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school }
    end
  end
  
  def compare
    @favorite_schools = session[:favorites].map {|x| School.find(x)}
    shared_variables
  end
  
  ####### AJAX #######
  
  def switch_tab
    respond_to do |format|
      format.js
    end
  end
  
  def favorite
    @school = School.find(params[:id])
    session[:favorites] ||= []
    session[:favorites] << @school.id unless session[:favorites].include?(@school.id)
    session[:favorites].present? ? @favorite_schools = session[:favorites].map {|x| School.find(x)} : @favorite_schools = []
    respond_to do |format|
      format.js
    end
  end
  
  def unfavorite
    @school = School.find(params[:id])
    session[:favorites].delete_if {|x| x == @school.id }
    session[:favorites].present? ? @favorite_schools = session[:favorites].map {|x| School.find(x)} : @favorite_schools = []
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def shared_variables
    @grade_levels = GradeLevel.all
    @grade_level = GradeLevel.find_by_number(session[:grade_level])
    @geocoded_address ||= geocode_address("#{session[:address]}, #{session[:zipcode]}")
    @assignment_zone = AssignmentZone.find_by_location(@geocoded_address).first

    walk_zone_schools = @grade_level.schools.find_all_within_radius(@geocoded_address, @grade_level.walk_zone_radius_in_meters).with_distance(@geocoded_address).order('distance ASC')
    assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone).with_distance(@geocoded_address).order('distance ASC') - walk_zone_schools
    citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide).with_distance(@geocoded_address).order('distance ASC') - walk_zone_schools
    [ [walk_zone_schools,"Walk Zone",1], [assignment_zone_schools,"Assignment Zone",2], [citywide_schools,"Citywide",3] ].each do |schools,type,index|
      schools.each do |s|
        s.eligibility = type
        s.eligibility_index = index
      end
    end
    @hidden_gems = (walk_zone_schools + assignment_zone_schools + citywide_schools).find_all {|x| x.hidden_gem == true}
    @walk_zone_schools = walk_zone_schools - @hidden_gems
    @assignment_zone_schools = assignment_zone_schools - @hidden_gems
    @citywide_schools = citywide_schools - @hidden_gems
    @all_schools = (@hidden_gems + @walk_zone_schools + @assignment_zone_schools + @citywide_schools)
    if params[:sibling_school] && (sib_school = @all_schools.find {|s| s.id == params[:sibling_school].to_i})
      #raise "in here"
      sib_school.eligibility = "Sibling School / "+sib_school.eligibility
      sib_school.eligibility_index = 0
    end
  end
end
