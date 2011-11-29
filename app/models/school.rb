class School < ActiveRecord::Base
  # acts_as_gmappable :lat => "lat", :lng => "lng"
  acts_as_mappable  :default_units => :miles, :lat_column_name => :lat, :lng_column_name => :lng
  
  has_many :grade_level_schools
  has_many :grade_levels, :through => :grade_level_schools
  #has_and_belongs_to_many :grade_levels
  belongs_to :assignment_zone
  belongs_to :city
  belongs_to :neighborhood
  belongs_to :parcel
  belongs_to :principal
  belongs_to :state
  has_many :geocode_grade_walkzone_schools
  
  attr_accessor :eligibility, :eligibility_index
  # before_save :recalculate_school_assignment so if they change a school location or add a school it will be reindexed TODO
  before_save :geocode_address
  before_save :create_permalink
  
  
  if Rails.env == 'development'
    has_attached_file :image, :styles => {:original => "850x600", :slider => "490x330#", :large => "280x200", :medium => "120x90>", :small => "95x71#", :thumb => "85x63#", :icon => "50x50#"}, :path => "#{Rails.root}/public/system/images/:id/:style/:filename"
  elsif Rails.env == 'production'
    has_attached_file :image, 
                      :styles => {:original => "850x600", :slider => "490x330#", :large => "850x565#", :medium => "120x90>", :small => "95x71#", :thumb => "85x63", :icon => "50x50#"}, 
                      :storage => :s3,
                      :bucket => 'discoverbps',
                      :path => "schools/:id/:style/:filename",
                      :s3_credentials => {
                        :access_key_id => ENV['S3_KEY'],
                        :secret_access_key => ENV['S3_SECRET']
                      }
  end
  
  ##### CLASS METHODS #####
  
  class << self
    def walkzone_schools(geocode, grade_level, geocoded_address)
      schools = self.joins(:geocode_grade_walkzone_schools)
        .where(:geocode_grade_walkzone_schools => {:geocode_id => geocode, :grade_level_id => grade_level})
        .select("geocode_grade_walkzone_schools.transportation_eligible as transportation_eligible")
        .select("schools.*")
        .with_distance(geocoded_address)
        .includes(:grade_level_schools, :city)
        .order('distance ASC')
      [[schools,"Walk Zone",1]].each do |schools,type,index|
        schools.each do |s|
          s.eligibility = type
          s.eligibility_index = index
        end
      end
      schools
    end
  end
  
  def self.with_distance(address)
    self.joins(:parcel).select("ST_Distance(parcels.geometry, ST_GeomFromText('POINT(#{address.lng} #{address.lat})')) as distance")
  end
  
  def self.find_all_within_radius(address, radius_in_meters)
    self.joins(:parcel).where("ST_DWithin(parcels.geometry, ST_GeomFromText('POINT(#{address.lng} #{address.lat})'), #{radius_in_meters})")
  end
  
  ##### INSTANCE METHODS #####
  
  def grade(number)
    grade_level_schools.detect {|x| x.grade_number == number}
  end

  def geocode_address
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
  
  private
  
  def create_permalink
    string = self.name
    separator = "-"
    max_size = 127
    ignore_words = ['a', 'an', 'the', 'la']
    permalink = string.gsub("'", separator)
    permalink.downcase!
    ignore_words.each do |word|
      permalink.gsub!(/^#{word} /, '')
    end
    permalink.gsub!(/[^a-z0-9]+/, separator)
    permalink = permalink.to(max_size)
    self.permalink = permalink.gsub(/^\\#{separator}+|\\#{separator}+$/, '')
  end
end
