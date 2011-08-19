module ApplicationHelper
  def address_helper
    if @geocoded_address.present? && @geocoded_address.success == true
      "#{@geocoded_address.street_address}, #{@geocoded_address.city}, #{@geocoded_address.state}"
    elsif params[:address].present?
      params[:address]
    end
  end
end
