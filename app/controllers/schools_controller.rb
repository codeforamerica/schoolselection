class SchoolsController < ApplicationController
  layout 'application', :except => :show
  
  def index
    @grade_levels = GradeLevel.all
    if params[:address].try(:present?)
      address, session[:address] = params[:address], params[:address]
    else
      address = session[:address]
    end
    if params[:zipcode].try(:present?)
      zipcode, session[:zipcode] = params[:zipcode], params[:zipcode]
    else
      zipcode = session[:zipcode]
    end
    if params[:grade_level].try(:present?)
      grade_level, session[:grade_level] = params[:grade_level], params[:grade_level]
    else
      grade_level = session[:grade_level]
    end
    @address = "#{address}, #{zipcode}"
    @geocoded_address = geocode_address(@address) if address.present?    
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
  
  def shared_instance_variables
    session[:favorites].present? ? @favorite_schools = session[:favorites].map {|x| School.find(x)} : @favorite_schools = []
    @grade_level = GradeLevel.find_by_number(session[:grade_level])
    @assignment_zone = AssignmentZone.find_by_location(@geocoded_address).first
    
    @walk_zone_schools = @grade_level.schools.find_all_within_radius(@geocoded_address, @grade_level.walk_zone_radius_in_meters).with_distance(@geocoded_address).order('distance ASC')
    @assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
    @citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
    @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)
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
