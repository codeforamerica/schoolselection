class SchoolPdf < Prawn::Document
  require "open-uri"
  def initialize(school, grade_level, view, session)
    super(top_margin: 35)
    @school = school
    @grade_level = grade_level
    @view = view
    @session = session
    @grade = @school.grade(@session[:grade_level])
    
    image "#{Rails.root}/public/images/logo-blue-small.png"
    title
    description
    information
    transportation
    admissions
    mcas
    page_url
  end
  
  def notices
    move_down 30
    if @school.id.to_s == @session[:sibling_school]
      table([["This school qualifies for Sibling Priority"]], :cell_style => {:align => :center, :font_style => :bold, :background_color => "faf4a5", :border_width => 0, :width => 540})
      move_down 10
    end
    if @school.eligibility =~ /Walk Zone/
      table([["This school qualifies for Walk Zone Priority"]], :cell_style => {:align => :center, :font_style => :bold, :background_color => "a5e188", :border_width => 0, :width => 540})
      move_down 10
    end
    if @school.special_admissions?
      table([["This school requires special admissions"]], :cell_style => {:align => :center, :font_style => :bold, :background_color => "e3e4e5", :border_width => 0, :width => 540})
      move_down 10
    end
    if @school.id.to_s == @session[:sibling_school] || @school.eligibility =~ /Walk Zone/ || @school.special_admissions?
      move_down 15
    end
  end
  
  def title
    move_down 30
    text "#{@school.name}", :size => 24, :style => :bold
  end
  
  def description
    move_down 10
    text "#{@school.description}" 
  end
  
  #### GENERAL INFORMATION #####
  
  def information
    move_down 20
    text "General Information", :size => 14, :style => :bold
    table [["Address:", "#{@school.address}, #{@school.city.try(:name)} MA, #{@school.zipcode}"]] + [["Phone:", @school.phone]] + [["Fax:", @school.fax]] + [["Website", @school.website]] + [["Email:", @school.email]] + [["Hours:", @school.grade(@session[:grade_level]).try(:hours)]] + [["Surround Care:", @school.surround_care_hours]]
  end
  
  #### TRANSPORTATION ####

  def transportation
    move_down 20
    text "Transportation", :size => 14, :style => :bold
    table [["Eligibility", "Distance", "Walk Time", "Drive Time"]] + [[transportation_eligibility, distance_in_miles_from_meters(@school.distance), walk_time(@school.distance), drive_time(@school.distance)]] do
      row(0).font_style = :italic
    end
  end
  
  def transportation_eligibility
    if @school.eligibility =~ /Walk Zone/
      "Walk Zone"
    elsif @grade_level.name == "High"
      "MBTA"
    else
      "School Bus"
    end
  end
  
  def distance_in_miles_from_meters(distance)
    "#{@view.distance_in_miles_from_meters(distance)} mi"
  end
  
  def walk_time(distance)
    "#{@view.walk_time(distance)} min"
  end

  def drive_time(distance)
    "#{@view.drive_time(distance)} min"
  end
  
  #### ADMISSIONS ####
  
  def admissions
    if @grade.open_seats.present?
      move_down 25
      text "Admissions", :size => 14, :style => :bold
      table [["Open Seats", "1st Choices", "2nd Choices", "3rd Choices", "Applicants per Open Seat"]] + [[@grade.open_seats, @grade.first_choice, @grade.second_choice, @grade.third_choice, "#{@grade.demand.to_i} : 1"]] do
        row(0).font_style = :italic
      end
    end
  end
  
  #### MCAS ####
  
  def mcas
    if @grade.mcas_ela_advanced.present?
      move_down 25
      text "MCAS Scores", :size => 14, :style => :bold
      table [["", "Advanced", "Proficient", "Needs Improvement", "Warning/Failing"]] + 
            [["English", number_to_percentage(@grade.mcas_ela_advanced), number_to_percentage(@grade.mcas_ela_proficient), number_to_percentage(@grade.mcas_ela_needsimprovement), number_to_percentage(@grade.mcas_ela_failing)]] +
             [["Math", number_to_percentage(@grade.mcas_math_advanced), number_to_percentage(@grade.mcas_math_proficient), number_to_percentage(@grade.mcas_math_needsimprovement), number_to_percentage(@grade.mcas_math_failing)]] do
        row(0).font_style = :italic
      end    
    end
  end
  
  def number_to_percentage(number)
    @view.number_to_percentage((number * 100), :precision => 0)
  end
  
  def page_url
    move_down 30
    formatted_text [{:text => "http://www.discoverbps.org/schools/#{@school.permalink}", :link => "http://www.discoverbps.org/schools/#{@school.permalink}", :color => '008cd9', :style => :bold, :valign => :bottom}]
  end
end