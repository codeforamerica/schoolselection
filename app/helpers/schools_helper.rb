module SchoolsHelper
  
  def distance(distance)
    "#{distance.to_f.round(2)}&nbsp;miles"
  end
  
  def distance_in_miles_from_meters(distance)
    number_with_precision((distance.to_f / METERS_PER_MILE), :precision => 2)
  end
  
  def walk_time(distance)
    (distance.to_f / WALK_TIME_METERS_PER_MINUTE).floor
  end

  def drive_time(distance)
    (distance.to_f / DRIVE_TIME_METERS_PER_MINUTE).floor
  end
  
  def eligibility_title(school)
    if school.eligibility =~ /Walk Zone/
      "Walk&nbsp;Zone"
    elsif school.eligibility =~ /Assignment Zone/
      "Assignment&nbsp;Zone"
    elsif school.eligibility =~ /Citywide/
      "Citywide"
    end      
  end
  
  def admissions_odds(open_seats, first_choices)
    if open_seats.blank? || first_choices.blank?
      '&nbsp'
    elsif (open_seats.to_f / first_choices.to_f) >= 1
      'High'
    elsif (open_seats.to_f / first_choices.to_f) > 0.66
      'High'
    elsif (open_seats.to_f / first_choices.to_f) > 0.33
      'Medium'
    elsif (open_seats.to_f / first_choices.to_f) > 0
      'Low'
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
  
  def map_legend
    %{
      #{image_tag('green-marker-small.png')} Walk Zone School <br />
      #{image_tag('yellow-marker-small.png')} Assignment Zone School <br />
      #{image_tag('gray-marker-small.png')} Citywide School"
    }
  end
  
  include EncodePolyline
  def static_schools_map(width, height)
    zone_boundry = encode_line(simplify_points(@assignment_zone.geometry[0].exterior_ring.points,0.001,0.01))
    image_tag("http://maps.google.com/maps/api/staticmap?" + 
      "size=#{width}x#{height}" + 
      '&zoom=10' +
      "&maptype=roadmap" +
      "&sensor=false" +
      "&markers=size:tiny|color:0x53e200|#{@walk_zone_schools.map {|x|"#{x.lat},#{x.lng}"} * "|" }" +
      "&markers=size:tiny|color:0xfcef08|#{@assignment_zone_schools.map {|x|"#{x.lat},#{x.lng}"} * "|" }" +
      "&markers=size:tiny|color:0xc8c8c8|#{@citywide_schools.map {|x|"#{x.lat},#{x.lng}"} * "|" }" +
      "&path=fillcolor:0xfcef08|color:0x0000ff|weight:1|enc:#{zone_boundry}", 
      :alt => "Map View", :class => 'static-map-image')
  end
  
  def static_school_map(width, height, color)
    "http://maps.google.com/maps/api/staticmap?" + 
    "size=#{width}x#{height}" + 
    '&zoom=14' +
    "&maptype=roadmap" +
    "&sensor=false" +
    "&markers=size:large|color:0x#{color}|#{[@school].map {|x|"#{x.lat},#{x.lng}"} * "|" }"
  end
  
  ####### SINGLE SCHOOL MAP #######
  
  def school_map
    gmaps("markers" => {
      "data" => markers_json,
      "options" => {"list_container" => "markers_list"}},
      "polygons" => {
        "data" => assignment_zones_json,
        "options" => {
          "fillColor" => "#ffff00", "fillOpacity" => 0.3,
          "strokeColor" => "#000000", "strokeWeight" => 1.5, 'strokeOpacity' => 0.6 
        }
      },
      "map_options" => {"provider" => "googlemaps", "auto_adjust" => true }
    )
  end
  
  ####### ALL SCHOOLS MAP #######
  
  def walk_zone_map
    gmaps("markers" => {
      "data" => markers_json,
      "options" => {"list_container" => "markers_list"}},
      "polygons" => {
        "data" => assignment_zones_json,
        "options" => {
          "fillColor" => "#ffff00", "fillOpacity" => 0.3,
          "strokeColor" => "#000000", "strokeWeight" => 1.5, 'strokeOpacity' => 0.6
        }
      },
      "map_options" => {"provider" => "googlemaps", "auto_adjust" => true}
    )
  end
  
  def assignment_zones_json
    @assignment_zone.shape_to_json
  end
  
  def markers_json
    array = []
    array << @walk_zone_schools.map {|x| create_listing_hash(x, 'green')}
    array << @assignment_zone_schools.map {|x| create_listing_hash(x, 'yellow')}
    array << @citywide_schools.map {|x| create_listing_hash(x, 'gray')}    
    array << [{
      :sidebar => @geocoded_address.street_address,
      :lng => @geocoded_address.lng, :lat => @geocoded_address.lat,
      :picture => '/assets/icons/home.png',
      :width => '18', :height => '15',
      :marker_anchor => [9, 7]
    }]
    array.flatten.to_json
  end
  
  def create_listing_hash(x, color)
    {
      :lng => x.lng, :lat => x.lat,
      :picture => "/images/#{color}-marker.png",
      :width => '21', :height => '38',
      :shadow_picture => '/images/shadow.png',
      :shadow_width => '43', :shadow_height => '38',
      :shadow_anchor => [10, 33],
      :description => %{
        <ul class='horizontal-list'>
          <li>#{image_tag(x.image(:thumb))}</li>
          <li>
            <h3 class='bold'>#{x.name}</h3>
            #{x.address}<br />
            #{x.city.try(:name)} MA, #{x.zipcode}<br />
            <strong>#{link_to 'View More', school_path(x.permalink)}</strong>
          </li>
        </ul>
      },
      :sidebar => "#{x.name}"
    }
  end
end
