module Geography
    
  def geocode_address(address)
    boston = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA')
    Geokit::Geocoders::GoogleGeocoder.geocode(address, :bias => boston.suggested_bounds)
    # Geokit::Geocoders::MultiGeocoder.geocode(address)
  end

end