module SchoolsHelper
  def results_title(params)
    if params[:address].present?
      "<h2>#{params[:grade_level]}s within #{@walk_zone.distance} miles of #{@location.street_address}, #{@location.city}, #{@location.state}<span class='small italic'>&nbsp;(#{@walk_zone_schools.size} results)</span></h2>"
    elsif params[:grade_level].present?
      "<h2>#{params[:grade_level]}s <span class='small italic'>&nbsp;(#{@walk_zone_schools.size} results)</span></h2>"
    else
      "<h2>All Schools</h2>"
    end
  end
end
