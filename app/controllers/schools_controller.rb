class SchoolsController < ApplicationController
  # layout 'application', :except => :show
  
  def index
    address, session[:address] = params[:address], params[:address]
    zipcode, session[:zipcode] = params[:zipcode], params[:zipcode]
    grade_level, session[:grade_level] = params[:grade_level], params[:grade_level]
    session[:sibling_school] = params[:sibling_school]
    session[:favorites].present? ? @favorite_schools = session[:favorites].map {|x| School.find(x)} : @favorite_schools = []
    m, @street_number, @street_name = session[:address].match(/(\d+)\s+(.*)/).to_a
    
    if address.blank?
      redirect_to(root_url, alert: "You must enter an address")
    elsif zipcode.blank?
      redirect_to(root_url, alert: "You must enter a zipcode")
    elsif m.blank?
      redirect_to(root_url, alert: "We couldn't locate that address - please try again")
    else
      @address_ranges = AddressRange.find_all_by_search_params(@street_number.to_i, @street_name, session[:zipcode])    
      if @address_ranges.blank?
        redirect_to(root_url, alert: "We couldn't locate that address - please try again.")
      else
        if @address_ranges.size == 1
          @address = @address_ranges.first
          @grade_levels = GradeLevel.all
          @grade_level = GradeLevel.find_by_number(session[:grade_level])
          @geocoded_address ||= geocode_address("#{session[:address]}, #{session[:zipcode]}")
          geocode = @address_ranges.first.geocode
          @assignment_zone = geocode.assignment_zone
          @walk_zone_schools = School.walkzone_by_geocode_and_grade(geocode,@grade_level)
            .select("schools.*")
            .with_distance(@geocoded_address)
            .includes(:grade_level_schools, :city)
            .order('distance ASC')
          @assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone)
            .select("schools.*")
            .with_distance(@geocoded_address)
            .includes(:grade_level_schools, :city)
            .order('distance ASC') - @walk_zone_schools
          @citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide)
            .select("schools.*")
            .with_distance(@geocoded_address)
            .includes(:grade_level_schools, :city)
            .order('distance ASC') - @walk_zone_schools

          [ [@walk_zone_schools,"Walk Zone",1], [@assignment_zone_schools,"Assignment Zone",2], [@citywide_schools,"Citywide",3] ].each do |schools,type,index|
            schools.each do |s|
              s.eligibility = type
              s.eligibility_index = index
            end
          end
          @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)

          if params[:sibling_school] && (sib_school = @all_schools.find {|s| s.id == params[:sibling_school].to_i})
            #raise "in here"
            sib_school.eligibility = "Sibling School / "+sib_school.eligibility
            sib_school.eligibility_index = 0
          end
        elsif @address_ranges.size > 1
          render 'pages/home'
        end    
      end
    end
        # respond_to do |format|
        #   format.html
        #   format.js
        #   format.pdf do
        #     pdf = SchoolsPdf.new(@all_schools, @grade_levels, @grade_level, @geocoded_address, view_context, session)
        #     send_data pdf.render, filename: "schools.pdf",
        #                           type: "application/pdf",
        #                           disposition: "inline"
        #   end
        # end
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
  
  def sort
    @favorite_schools = params[:school].map {|x| School.find(x)}
    session[:favorites] = []
    @favorite_schools.each do |school|
      session[:favorites] << school.id
    end
    render :nothing => true
  end
  
  private
  
  def shared_variables
    @grade_levels = GradeLevel.all
    @grade_level = GradeLevel.find_by_number(session[:grade_level])
    @geocoded_address ||= geocode_address("#{session[:address]}, #{session[:zipcode]}")

    m, num, street = session[:address].match(/(\d+)\s+(.*)/).to_a
    @address_ranges = AddressRange.find_by_search_params(num.to_i,street,session[:zipcode])
    @geocode = @address_range.first.geocode

    @assignment_zone = @geocode.assignment_zone

    @walk_zone_schools = School.walkzone_by_geocode_and_grade(@geocode,@grade_level)
      .select("schools.*")
      .with_distance(@geocoded_address)
      .includes(:grade_level_schools, :city)
      .order('distance ASC')
    @assignment_zone_schools = @grade_level.schools.where(:assignment_zone_id => @assignment_zone)
      .select("schools.*")
      .with_distance(@geocoded_address)
      .includes(:grade_level_schools, :city)
      .order('distance ASC') - @walk_zone_schools
    @citywide_schools = @grade_level.schools.where(:assignment_zone_id => AssignmentZone.citywide)
      .select("schools.*")
      .with_distance(@geocoded_address)
      .includes(:grade_level_schools, :city)
      .order('distance ASC') - @walk_zone_schools

    [ [@walk_zone_schools,"Walk Zone",1], [@assignment_zone_schools,"Assignment Zone",2], [@citywide_schools,"Citywide",3] ].each do |schools,type,index|
      schools.each do |s|
        s.eligibility = type
        s.eligibility_index = index
      end
    end
    @all_schools = (@walk_zone_schools + @assignment_zone_schools + @citywide_schools)
    
    if params[:sibling_school] && (sib_school = @all_schools.find {|s| s.id == params[:sibling_school].to_i})
      #raise "in here"
      sib_school.eligibility = "Sibling School / "+sib_school.eligibility
      sib_school.eligibility_index = 0
    end
  end
end
