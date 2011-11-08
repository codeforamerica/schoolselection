class SchoolsController < ApplicationController
  # layout 'application', :except => :show
  
  def index
    address, session[:address] = params[:address], params[:address]
    zipcode, session[:zipcode] = params[:zipcode], params[:zipcode]
    grade_level, session[:grade_level] = params[:grade_level], params[:grade_level]
    session[:sibling_school] = params[:sibling_school]
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
      format.pdf do
        pdf = SchoolsPdf.new(@all_schools, @grade_levels, @grade_level, @geocoded_address, view_context, session)
        send_data pdf.render, filename: "schools.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def show
    shared_variables
    session[:favorites].present? ? @favorite_schools = session[:favorites].map {|x| School.find(x)} : @favorite_schools = []
    @school = @all_schools.find {|x| x.permalink == params[:id] }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school }
      format.pdf do
        pdf = SchoolPdf.new(@school, @grade_level, view_context, session)
        send_data pdf.render, filename: "#{@school.permalink}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
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

    m, num, street = session[:address].match(/(\d+)\s+(.*)/).to_a
    address_range = AddressRange.find_by_address(num.to_i,street,session[:zipcode])
    #todo: make sure the address range is actually found, first
    @geocode = address_range.first.geocode
    @assignment_zone = @geocode.assignment_zone

    @walk_zone_schools = School.walkzone_by_geocode_and_grade(@geocode,@grade_level).with_distance(@geocoded_address).order('distance ASC')
    @assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
    @citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide).with_distance(@geocoded_address).order('distance ASC') - @walk_zone_schools
    [ [@walk_zone_schools,"Walk Zone",1], [@assignment_zone_schools,"Assignment Zone",2], [@citywide_schools,"Citywide",3] ].each do |schools,type,index|
      schools.each do |s|
        s.eligibility = type
        s.eligibility_index = index
      end
    end
    @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)

    # @hidden_gems = (walk_zone_schools + assignment_zone_schools + citywide_schools).find_all {|x| x.hidden_gem == true}
    # @walk_zone_schools = walk_zone_schools - @hidden_gems
    # @assignment_zone_schools = assignment_zone_schools - @hidden_gems
    # @citywide_schools = citywide_schools - @hidden_gems
    
    if params[:sibling_school] && (sib_school = @all_schools.find {|s| s.id == params[:sibling_school].to_i})
      #raise "in here"
      sib_school.eligibility = "Sibling School / "+sib_school.eligibility
      sib_school.eligibility_index = 0
    end
  end
end
