class School < ActiveRecord::Base
  acts_as_gmappable :lat => "lat", :lng => "lng"
  acts_as_mappable  :lat_column_name => :lat, :lng_column_name => :lng
  
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
    else
      School.all(:order => :name)
    end
  end
  
  def self.assignment_zone_schools(walk_zone, location)
    self.find(:all, :origin => location, :within => walk_zone.distance, :order => 'distance', :conditions => ['school_level_id IN (?)', walk_zone.school_levels])
  end
    
  def geocode_address!
    boston_bounds = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA').suggested_bounds
    geo = Geokit::Geocoders::GoogleGeocoder.geocode("#{address}, #{city.try(:name)}", :bias => boston_bounds)
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.lat, self.lng = geo.lat,geo.lng if geo.success
    self.save
  end
  
  def gmaps4rails_address
    #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{self.address}, #{self.city.try(:name)}, #{self.try(:state)}" 
  end
  
  def gmaps4rails_infowindow
    "<strong>#{self.name}</strong><br />#{self.address}<br />#{self.city.try(:name)}, #{self.state.try(:abbreviation)}"
  end

end
