class SchoolsController < ApplicationController
  layout 'application', :except => :show
  
  def index
    @grade_levels = GradeLevel.all
    address, session[:address] = params[:address], params[:address]
    zipcode, session[:zipcode] = params[:zipcode], params[:zipcode]
    grade_level, session[:grade_level] = params[:grade_level], params[:grade_level]
    
    @address = "#{address}, #{zipcode}"
    @geocoded_address = geocode_address(@address) if address.present?
    @favorites = School.find(session[:favorites]) if session[:favorites].present?
    
    if address.present? && grade_level.present? && @geocoded_address.success == true && AssignmentZone.find_by_location(@geocoded_address).present?
      @grade_level = GradeLevel.find_by_number(grade_level)
      @assignment_zone = AssignmentZone.find_by_location(@geocoded_address).first
      
      @walk_zone_schools = @grade_level.schools.find_all_within_radius(@geocoded_address, @grade_level.walk_zone_radius_in_meters).with_distance(@geocoded_address).order('distance ASC')
      @assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
      @citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
      @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)
    else
      @assignment_zones = AssignmentZone.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schools }
    end
  end

  def show
    @favorites = session[:favorites]
    @school = School.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school }
    end
  end
  
  def compare
    @favorites = School.find(session[:favorites])
  end
  
  def add
    @school = School.find(params[:id])
    session[:favorites] ||= []
    session[:favorites] << @school.id unless session[:favorites].include?(@school.id)
    respond_to do |format|
      format.html { redirect_to schools_url(address: params[:address], zipcode: params[:zipcode], grade_level: params[:grade_level]), notice: "#{@school.name} was added to your favorites" }
      format.json { render json: @school }
    end
  end
  
  def remove
    @school = School.find(params[:id])
    session[:favorites].delete_if {|x| x == @school.id }
    respond_to do |format|
      format.html { redirect_to schools_url(address: params[:address], zipcode: params[:zipcode], grade_level: params[:grade_level]), notice: "#{@school.name} was added to your favorites" }
      format.json { render json: @school }
    end
  end
end
