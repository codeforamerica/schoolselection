module SchoolsHelper
  
  def walk_zone_results_title(params)
    if params[:address].present?
      "<h2>WalkZone #{params[:grade_level]}s near #{@location.street_address}, #{@location.city}, #{@location.state}<span class='small italic'>&nbsp;(#{@walk_zone_schools.size} results)</span></h2>"
    elsif params[:grade_level].present?
      "<h2>#{params[:grade_level]}s <span class='small nobold'>&nbsp;(#{@walk_zone_schools.size} results)</span></h2>"
    else
      "<h2>All Schools <span class='small nobold'>&nbsp;(#{@walk_zone_schools.size} results)</span></h2>"
    end
  end
  
  def normal_results_title(params)
    if params[:address].present?
      "<h2>Other #{params[:grade_level]}s <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    elsif params[:grade_level].present?
      "<h2>#{params[:grade_level]}s <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    else
      "<h2>All Schools <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    end
  end

end
