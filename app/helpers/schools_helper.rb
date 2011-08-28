module SchoolsHelper
  
  def converted_address_params
    if @geocoded_address.present? && @geocoded_address.success == true
      "#{@geocoded_address.street_address}, #{@geocoded_address.city}, #{@geocoded_address.state}"
    elsif params[:address].present?
      params[:address]
    end
  end
  
  def distance(distance)
    "#{distance.to_f.round(2)}&nbsp;mi"
  end
  
  def walk_time(distance)
    "#{((distance.to_f / 3) * 60).floor}&nbsp;min"
  end
  
  def alert_message
    if @geocoded_address.present? && @geocoded_address.success == true && @walk_zone.blank?
      "<div class='alert'>The address you entered &mdash; '#{@address.titleize}' &mdash; could not be located within the Boston School District. Please try again.</div>"
    elsif (params[:address].present? || params[:zipcode].present?) && @geocoded_address.success == false
      "<div class='alert'>We couldn't locate that address &mdash; please try again.</div>"
    elsif params[:address].blank? && params[:zipcode].blank? && params[:grade_level].present?
      "<div class='alert'>Please enter an address and zipcode to see your eligible schools.</div>"
    end
  end
  
  def normal_results_title
    if params[:grade_level].blank?
      "<h2>All Schools <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    elsif @walk_zone_schools.present?
      "<h2>Other #{params[:grade_level]} schools <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    else
      "<h2>#{params[:grade_level].humanize} schools <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    end
  end
  
  ####### MAP JSON #######
  
  def walk_zone_map
    gmaps("markers" => {"data" => markers_json }, "circles" => {"data" => walk_zone_json }, "polygons" => {"data" => assignment_zones_json, "options" => { "fillColor" => "#ffff00", "fillOpacity" => 0.4, "strokeColor" => "#000000", "strokeWeight" => 1.5, 'strokeOpacity' => 0.6 }}, "map_options" => { "provider" => "googlemaps", "auto_adjust" => true })
  end
  
  def default_map
    gmaps("polygons" => {"data" => assignment_zones_json, "options" => { "fillColor" => "#ffff00", "fillOpacity" => 0.4, "strokeColor" => "#000000", "strokeWeight" => 1.5, 'strokeOpacity' => 0.5 }}, "map_options" => { "provider" => "googlemaps", "auto_adjust" => false, "center_latitude" => @map_center.lat, "center_longitude" => @map_center.lng, "zoom" => 11 })
  end
  
  def assignment_zones_json
    (@assignment_zones.map {|z| z.coordinates_hash}).to_json
  end
  
  def walk_zone_json
    [{:lng => @geocoded_address.lng, :lat => @geocoded_address.lat, :radius => @walk_zone.distance * 1609.344, :fillColor => '#61d60e', :fillOpacity => 0.5, :strokeColor => '#000000', :strokeOpacity => 0.6, :strokeWeight => 1.5}].to_json
  end
  
  def markers_json
    array = []
    array << @walk_zone_schools.map {|x| create_listing_hash(x, 'green')}
    array << @assignment_zone_schools.map {|x| create_listing_hash(x, 'yellow')}
    array << @citywide_schools.map {|x| create_listing_hash(x, 'gray')}    
    array << [{:lng => @geocoded_address.lng, :lat => @geocoded_address.lat, :picture => '/images/crosshair.png', :width => '9', :height => '9', :marker_anchor => [5, 7]}]
    array.flatten.to_json
  end
  
  def create_listing_hash(x, color)
    {:lng => x.lng, :lat => x.lat, :picture => "/images/#{color}-marker.png", :width => '21', :height => '38', :shadow_picture => '/images/shadow.png', :shadow_width => '43', :shadow_height => '38', :shadow_anchor => [10, 33], :description => "<strong>#{x.name}</strong><br />#{x.address}<br />#{x.city.try(:name)}, #{x.state.try(:abbreviation)}"}
  end
end
