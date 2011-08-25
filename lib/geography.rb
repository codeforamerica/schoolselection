module Geography
  
  BOSTON = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA')
  BOSTON_BOUNDS = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA').suggested_bounds
  
  def geocode_address(address)
    Geokit::Geocoders::GoogleGeocoder.geocode(address, :bias => BOSTON_BOUNDS)
    # Geokit::Geocoders::GoogleGeocoder.geocode(address)
  end
  
  def inside_polygon?(lat, lng, polygon)
    intersects = 0
    p1 = polygon[0]
    for i in 1..(polygon.size-1)
      p2 = polygon[i % polygon.size]
      if ((lat > [p1.lat,p2.lat].min) &&
        (lat <= [p1.lat,p2.lat].max) &&
        (lng <= [p1.lng,p2.lng].max) &&
        (p1.lat != p2.lat))
        xinters = (lat-p1.lat)*(p2.lng-p1.lng)/(p2.lat-p1.lat)
        p1.lng
        intersects += 1 if (p1.lng == p2.lng || lng <= xinters)
      end
      p1 = p2
    end
    (intersects % 2 == 1)
  end

end