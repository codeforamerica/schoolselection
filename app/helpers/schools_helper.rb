module SchoolsHelper
  
  def normal_results_title(params)
    if params[:grade_level].blank? || params[:grade_level] == 'All Schools'
      "<h2>All Schools <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    elsif params[:address].present?
      "<h2>Other #{params[:grade_level]}s <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    else
      "<h2>#{params[:grade_level]}s <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    end
  end

end
