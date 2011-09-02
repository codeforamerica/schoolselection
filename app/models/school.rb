class School < ActiveRecord::Base
  # acts_as_gmappable :lat => "lat", :lng => "lng"
  acts_as_mappable  :default_units => :miles, :lat_column_name => :lat, :lng_column_name => :lng
  
  has_and_belongs_to_many :grade_levels
  belongs_to :assignment_zone
  belongs_to :city
  belongs_to :mail_cluster
  belongs_to :principal
  belongs_to :school_group
  belongs_to :state
  
  serialize :parcel_coordinates # expects an array of [lat, lng] arrays
  
  # before_save :recalculate_school_assignment so if they change a school location or add a school it will be reindexed TODO
  before_save :geocode_address!
  
  ##### CLASS METHODS #####
  
  def self.find_all_with_school_level(school_level)
    if walk_zone = WalkZone.find_by_name(school_level)
      walk_zone.schools
    else
      School.all(:order => :name)
    end
  end
  
  def self.find_all_within_radius(address, radius_in_miles)
    # assume that SRID is 2249
    radius_in_feet = radius_in_miles * 5280
    self.where("ST_DWithin(parcel, ST_Transform(ST_GeomFromText('POINT(#{address.lng} #{address.lat})', 4326), 2249), #{radius_in_feet})")
  end
  
  # def self.walk_zone_schools(location, grade_level)
  #   self.find_within(grade_level.walk_zone_radius, :origin => location, :order => 'distance', :conditions => ['id IN (select school_id from grade_levels_schools where grade_level_id = ?)', grade_level.id])
  # end
  
  # def self.assignment_zone_schools(location, grade_level, assignment_zones)
  #   if grade_level.name == 'High'
  #     [] # all high schools should show up as citywide schools, not assignment zone schools
  #   else  
  #     assignment_zone_ids = assignment_zones.map {|x| x.id}
  #     self.find_beyond(grade_level.walk_zone_radius, :origin => location, :order => 'distance', :conditions => ['id IN (select school_id from grade_levels_schools where grade_level_id = ?) AND assignment_zone_id IN (?)', grade_level.id, assignment_zone_ids])
  #   end
  # end
  
  def self.citywide_schools(location, grade_level)
    assignment_zone = AssignmentZone.find_by_name('Citywide')
    self.find_beyond(grade_level.walk_zone_radius, :origin => location, :order => 'distance', :conditions => ['id IN (select school_id from grade_levels_schools where grade_level_id = ?) AND assignment_zone_id = ?', grade_level.id, assignment_zone.id])
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
end
