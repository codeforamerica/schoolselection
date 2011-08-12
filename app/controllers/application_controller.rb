class ApplicationController < ActionController::Base
  protect_from_forgery
  BOSTON = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA')
  BOSTON_BOUNDS = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA').suggested_bounds
end
