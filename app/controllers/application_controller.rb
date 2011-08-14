class ApplicationController < ActionController::Base
  protect_from_forgery
  BOSTON = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA')
  BOSTON_BOUNDS = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA').suggested_bounds
  
  def geocode_address(address)
    Geokit::Geocoders::GoogleGeocoder.geocode(address, :bias => BOSTON_BOUNDS)
  end
  
end
