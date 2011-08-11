class School < ActiveRecord::Base
  acts_as_mappable  :lat_column_name => :latitude,
                    :lng_column_name => :longitude
  
  has_and_belongs_to_many :walk_zones
  belongs_to :assignment_zone
  belongs_to :city
  belongs_to :mail_cluster
  belongs_to :principal
  belongs_to :school_group
  belongs_to :school_level
  belongs_to :school_type
  belongs_to :state
  
  def self.school_level_finder(school_level)
    if school_level == "Elementary School"
      WalkZone.find_by_distance(1.0).schools
    elsif school_level == "Middle School"
      WalkZone.find_by_distance(1.5).schools
    elsif school_level == "High School"
      WalkZone.find_by_distance(2.0).schools
    end
  end
    
  def geocode_address!
    boston_bounds = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA').suggested_bounds
    geo = Geokit::Geocoders::GoogleGeocoder.geocode("#{address}, #{city.try(:name)}", :bias => boston_bounds)
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.latitude, self.longitude = geo.lat,geo.lng if geo.success
    self.save
  end
end
