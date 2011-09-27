class SchoolsController < ApplicationController
  layout 'application', :except => :show
  
  def index
    @grade_levels = GradeLevel.all
    address, session[:address] = params[:address], params[:address]
    zipcode, session[:zipcode] = params[:zipcode], params[:zipcode]
    grade_level, session[:grade_level] = params[:grade_level], params[:grade_level]
    
    @address = "#{address}, #{zipcode}"
    @geocoded_address = geocode_address(@address) if address.present?
    session[:favorites].present? ? @favorite_schools = School.find(session[:favorites]) : @favorite_schools = []
    session[:hidden].present? ? @hidden_schools = School.find(session[:hidden]) : @hidden_schools = []
    
    if address.present? && grade_level.present? && @geocoded_address.success == true && AssignmentZone.find_by_location(@geocoded_address).present?
      @grade_level = GradeLevel.find_by_number(grade_level)
      @assignment_zone = AssignmentZone.find_by_location(@geocoded_address).first
      
      @walk_zone_schools = @grade_level.schools.find_all_within_radius(@geocoded_address, @grade_level.walk_zone_radius_in_meters).with_distance(@geocoded_address).order('distance ASC')
      @assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
      @citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
      @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)
      @visible_schools = (@all_schools - @hidden_schools)
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
    session[:favorites].present? ? @favorite_schools = School.find(session[:favorites]) : @favorite_schools = []
    session[:hidden].present? ? @hidden_schools = School.find(session[:hidden]) : @hidden_schools = []
    @geocoded_address = geocode_address(session[:address])
    @grade_level = GradeLevel.find_by_number(session[:grade_level])
    @assignment_zone = AssignmentZone.find_by_location(@geocoded_address).first
    
    @walk_zone_schools = @grade_level.schools.find_all_within_radius(@geocoded_address, @grade_level.walk_zone_radius_in_meters).with_distance(@geocoded_address).order('distance ASC')
    @assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
    @citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
    @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)
    @visible_schools = (@all_schools - @hidden_schools)
    @school = @all_schools.find {|x| x.id == params[:id].to_i}
    session[:favorites] ||= []
    session[:favorites] << @school.id unless session[:favorites].include?(@school.id)
    respond_to do |format|
      format.js
    end
  end
  
  def unfavorite
    session[:favorites].present? ? @favorite_schools = School.find(session[:favorites]) : @favorite_schools = []
    session[:hidden].present? ? @hidden_schools = School.find(session[:hidden]) : @hidden_schools = []
    @geocoded_address = geocode_address(session[:address])
    @grade_level = GradeLevel.find_by_number(session[:grade_level])
    @assignment_zone = AssignmentZone.find_by_location(@geocoded_address).first
    
    @walk_zone_schools = @grade_level.schools.find_all_within_radius(@geocoded_address, @grade_level.walk_zone_radius_in_meters).with_distance(@geocoded_address).order('distance ASC')
    @assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
    @citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
    @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)
    @visible_schools = (@all_schools - @hidden_schools)
    @school = @all_schools.find {|x| x.id == params[:id].to_i}
    session[:favorites].delete_if {|x| x == @school.id }
    respond_to do |format|
      format.js
    end
  end
  
  def hide
    @school = School.find(params[:id])
    session[:favorites].delete_if {|x| x == @school.id }
    session[:hidden] ||= []
    session[:hidden] << @school.id unless session[:hidden].include?(@school.id)
    respond_to do |format|
      format.js
    end
  end
  
  def unhide
    session[:favorites].present? ? @favorite_schools = School.find(session[:favorites]) : @favorite_schools = []
    session[:hidden].present? ? @hidden_schools = School.find(session[:hidden]) : @hidden_schools = []
    @geocoded_address = geocode_address(session[:address])
    @grade_level = GradeLevel.find_by_number(session[:grade_level])
    @assignment_zone = AssignmentZone.find_by_location(@geocoded_address).first
    
    @walk_zone_schools = @grade_level.schools.find_all_within_radius(@geocoded_address, @grade_level.walk_zone_radius_in_meters).with_distance(@geocoded_address).order('distance ASC')
    @assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
    @citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
    @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)
    @visible_schools = (@all_schools - @hidden_schools)
    @school = @all_schools.find {|x| x.id == params[:id].to_i}
    session[:hidden] ||= []
    session[:hidden].delete_if {|x| x == @school.id }
    respond_to do |format|
      format.js
    end
  end
end
