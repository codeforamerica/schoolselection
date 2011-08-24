class School < ActiveRecord::Base
  acts_as_gmappable :lat => "lat", :lng => "lng"
  acts_as_mappable  :default_units => :miles, :lat_column_name => :lat, :lng_column_name => :lng
  
  has_and_belongs_to_many :walk_zones
  belongs_to :assignment_zone
  belongs_to :city
  belongs_to :mail_cluster
  belongs_to :principal
  belongs_to :school_group
  belongs_to :school_level
  belongs_to :school_type
  belongs_to :state
  
  ##### CLASS METHODS #####
  
  def self.find_all_with_school_level(school_level)
    if walk_zone = WalkZone.find_by_name(school_level)
      walk_zone.schools
    else
      School.all(:order => :name)
    end
  end
  
  def self.walk_zone_schools(location, walk_zone)
    self.find_within(walk_zone.distance, :origin => location, :order => 'distance', :conditions => ['school_level_id IN (?)', walk_zone.school_levels])
  end
  
  def self.assignment_zone_schools(location, walk_zone, assignment_zones)
    assignment_zone_ids = assignment_zones.map {|x| x.id}
    self.find_beyond(walk_zone.distance, :origin => location, :order => 'distance', :conditions => ['school_level_id IN (?) AND assignment_zone_id IN (?)', walk_zone.school_levels, assignment_zone_ids])
    # assignment_zones.map {|x| x.schools_by_grade_level(grade_level)}.flatten - walk_zone_schools
  end
  
  def self.citywide_schools(location, walk_zone)
    assignment_zone = AssignmentZone.find_by_name('Citywide')
    self.find_beyond(walk_zone.distance, :origin => location, :order => 'distance', :conditions => ['school_level_id IN (?) AND assignment_zone_id = ?', walk_zone.school_levels, assignment_zone.id])
  end
  
  ##### INSTANCE METHODS #####
    
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
