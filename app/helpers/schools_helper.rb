module SchoolsHelper
  
  def search_message(params)
    if params[:address].present? && @geocoded_address.success == false
      "<div class='alert'>We couldn't locate that address &mdash; please try again.</div>"
    elsif params[:address].blank? && params[:grade_level] == 'All Schools'
      "<div class='notice'>Please enter your address and select a grade level to see your walk zone schools.</div>"
    elsif params[:address].blank? && params[:grade_level].present?
      "<div class='notice'>Please enter an address to see your walk zone schools.</div>"
    elsif params[:address].present? && params[:grade_level] == 'All Schools'
      "<div class='notice'>Please select a grade level to see your walk zone schools.</div>"
    elsif params[:address].blank? && params[:grade_level].blank?
      "<div class='notice'>Please select a grade level to see your walk zone schools.</div>"
    end
  end
  
  def normal_results_title(params)
    if params[:grade_level].blank? || params[:grade_level] == 'All Schools'
      "<h2>All Schools <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    elsif @walk_zone_schools.present?
      "<h2>Other #{params[:grade_level]}s <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    else
      "<h2>#{params[:grade_level]}s <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    end
  end

end
