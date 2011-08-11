class School < ActiveRecord::Base
  acts_as_mappable  :lat_column_name => :latitude,
                    :lng_column_name => :longitude
  
  belongs_to :assignment_zone
  belongs_to :city
  belongs_to :mail_cluster
  belongs_to :principal
  belongs_to :school_group
  belongs_to :school_level
  belongs_to :school_type
  belongs_to :state
    
  def geocode_address!
    boston_bounds = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA').suggested_bounds
    geo = Geokit::Geocoders::GoogleGeocoder.geocode("#{address}, #{city.try(:name)}", :bias => boston_bounds)
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.latitude, self.longitude = geo.lat,geo.lng if geo.success
    self.save
  end
end
