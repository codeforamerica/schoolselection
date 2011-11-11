module ApplicationHelper
  
  def search_params(options={})
    { :address => params[:address], :zipcode => params[:zipcode], :grade_level => params[:grade_level], :sibling_school => params[:sibling_school] }.merge(options)
  end
end
