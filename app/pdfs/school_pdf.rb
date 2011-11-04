class SchoolPdf < Prawn::Document
  def initialize(school, grade_level, view, session)
    super(top_margin: 35)
    @school = school
    @grade_level = grade_level
    @view = view
    @session = session
    
    image "#{Rails.root}/public/images/logo-blue-small.png"
    notices
    title
    description
    transportation
    admissions
    created_at
  end
  
  def notices
    move_down 30
    if @school.id.to_s == @session[:sibling_school]
      text "This school qualifies for Sibling Priority"
      move_down 10
    end
    if @school.eligibility =~ /Walk Zone/
      text "This school qualifies for Walk Zone Priority"
      move_down 10
    end
    if @school.special_admissions?
      text "This school requires special admissions"
      move_down 10
    end
  end
  
  def title
    text "#{@school.name}", :size => 24, :style => :bold
  end
  
  def description
    move_down 10
    text "#{@school.description}" 
  end
  
  #### TRANSPORTATION ####

  def transportation
    move_down 20
    text "Transportation", :size => 16, :style => :bold
    table [["Eligibility", "Distance", "Drive Time"]] + [[transportation_eligibility, distance_in_miles_from_meters(@school.distance), drive_time(@school.distance)]]
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
  
  def drive_time(distance)
    "#{@view.drive_time(distance)} min"
  end
  
  #### ADMISSIONS ####
  
  def admissions
    move_down 25
    grade = @school.grade(@session[:grade_level])
    text "Admissions", :size => 16, :style => :bold
    table [["Open Seats", "1st Choices", "2nd Choices", "3rd Choices", "Applicants per Open Seat"]] + [[grade.open_seats, grade.first_choice, grade.second_choice, grade.third_choice, "#{grade.demand.to_i} : 1"]]    
  end
  
  
  def line_items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_item_rows
    [["Product", "Qty", "Unit Price", "Full Price"]] +
    @order.line_items.map do |item|
      [item.name, item.quantity, price(item.unit_price), price(item.full_price)]
    end
  end
  
  def total_price
    move_down 15
    text "Total Price: #{price(@order.total_price)}", size: 16, style: :bold
  end
  
  def created_at
    move_down 20
    text "#{Date.today}"
  end
end