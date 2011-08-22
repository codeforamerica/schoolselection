module SchoolsHelper
  
  def converted_address_params
    if @geocoded_address.present? && @geocoded_address.success == true
      "#{@geocoded_address.street_address}, #{@geocoded_address.city}, #{@geocoded_address.state}"
    elsif params[:address].present?
      params[:address]
    end
  end
  
  def alert_message
    if @geocoded_address.present? && @geocoded_address.success == true && @walk_zone.blank?
      "<div class='alert'>The address you entered &mdash; '#{@geocoded_address.street_address} #{@geocoded_address.city}, #{@geocoded_address.state}' &mdash; could not be located within the Boston School District. Please try again.</div>"
    elsif params[:address].present? && @geocoded_address.success == false
      "<div class='alert'>We couldn't locate that address &mdash; please try again.</div>"
    elsif params[:address].blank? && params[:grade_level].present?
      "<div class='alert'>Please enter an address to see your eligible schools.</div>"
    end
  end
  
  def normal_results_title
    if params[:grade_level].blank?
      "<h2>All Schools <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    elsif @walk_zone_schools.present?
      "<h2>Other #{params[:grade_level]}s <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    else
      "<h2>#{params[:grade_level]}s <span class='small nobold'>&nbsp;(#{@schools.size} results)</span></h2>"
    end
  end
  
  def assignment_zones_json
    (@assignment_zones.map {|az| az.geokitted_coordinates}).to_json
  end
  
  def walk_zone_json
    "[{'lng': #{@geocoded_address.lng}, 'lat': #{@geocoded_address.lat}, 'radius': #{@walk_zone.distance * 1609.344}, 'fillColor': '#33cc00', 'fillOpacity': 0.35, 'strokeColor': '#000000', 'strokeOpacity': 0.6, 'strokeWeight': 1.5}]"
  end
  
  def markers_json
    (@walk_zone_schools + @assignment_zone_schools.flatten + @citywide_schools).to_gmaps4rails
  end
  
  def walk_zone_map
    gmaps("markers" => {"data" => markers_json}, "circles" => {"data" => walk_zone_json }, "polygons" => {"data" => assignment_zones_json, "options" => { "fillColor" => "#ffff00", "fillOpacity" => 0.35, "strokeColor" => "#000000", "strokeWeight" => 1.5, 'strokeOpacity' => 0.5 }}, "map_options" => { "provider" => "googlemaps", "auto_adjust" => true })
  end
  
  def default_map
    gmaps("polygons" => {"data" => assignment_zones_json, "options" => { "fillColor" => "#ffff00", "fillOpacity" => 0.4, "strokeColor" => "#000000", "strokeWeight" => 1.5, 'strokeOpacity' => 0.5 }}, "map_options" => { "provider" => "googlemaps", "auto_adjust" => false, "center_latitude" => @map_center.lat, "center_longitude" => @map_center.lng, "zoom" => 11 })
  end
  
end
