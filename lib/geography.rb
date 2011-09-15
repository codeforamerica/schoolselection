module Geography
  
  BOSTON = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA')
  
  def geocode_address(address)
    # Geokit::Geocoders::GoogleGeocoder.geocode(address, :bias => BOSTON.suggested_bounds)
    Geokit::Geocoders::MultiGeocoder.geocode(address)
  end

end