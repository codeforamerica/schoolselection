module Geography
    
  def geocode_address(address)
    # BOSTON ||= Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA')
    # Geokit::Geocoders::GoogleGeocoder.geocode(address, :bias => BOSTON.suggested_bounds)
    Geokit::Geocoders::MultiGeocoder.geocode(address)
  end

end