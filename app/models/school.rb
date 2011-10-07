class School < ActiveRecord::Base
  # acts_as_gmappable :lat => "lat", :lng => "lng"
  acts_as_mappable  :default_units => :miles, :lat_column_name => :lat, :lng_column_name => :lng
  
  has_and_belongs_to_many :grade_levels, :uniq => true
  has_many :grade_level_hours
  has_many :grade_level_admissions, :class_name => "SchoolGradeAdmission", :foreign_key => "school_id"
  belongs_to :assignment_zone
  belongs_to :city
  belongs_to :neighborhood
  belongs_to :mail_cluster
  belongs_to :parcel
  belongs_to :principal
  belongs_to :school_group
  belongs_to :state
  
  attr_accessor :eligibility, :eligibility_index
  # before_save :recalculate_school_assignment so if they change a school location or add a school it will be reindexed TODO
  # before_save :geocode_address!
  
  ##### CLASS METHODS #####
  
  def self.with_distance(address)
    self.joins(:parcel).select("ST_Distance(parcels.geometry, ST_GeomFromText('POINT(#{address.lng} #{address.lat})')) as distance")
  end
  
  def self.find_all_within_radius(address, radius_in_meters)
    self.joins(:parcel).where("ST_DWithin(parcels.geometry, ST_GeomFromText('POINT(#{address.lng} #{address.lat})'), #{radius_in_meters})")
  end
  
  ##### INSTANCE METHODS #####
  
  def hours_by_grade_level(number)
    self.grade_level_hours.find_by_grade_level_number(number)
  end

  def geocode_address!
    # boston_bounds = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA').suggested_bounds
    geo = Geokit::Geocoders::MultiGeocoder.geocode("#{address}, #{city.try(:name)}, MA, #{zipcode}")
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.lat, self.lng = geo.lat,geo.lng if geo.success
    self.save
  end
  
  def gmaps4rails_address
    #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{self.address}, #{self.city.try(:name)}, #{self.try(:state)}" 
  end
end
