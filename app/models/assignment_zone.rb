class AssignmentZone < ActiveRecord::Base
  has_many :schools
  
  # before_save :recalculate_included_schools so if they change the zones the schools will be reindexed TODO
  
  ####### CLASS METHODS #######
  
  def self.find_by_location(location)
    self.where("ST_Intersects(ST_GeomFromText('POINT(#{location.lng} #{location.lat})'), geometry)")
  end
  
  def self.citywide
    self.find_by_name('Citywide')
  end
  
  ####### INSTANCE METHODS #######
  
  def shape_to_json
    hash = RGeo::GeoJSON.encode(geometry)
    [hash["coordinates"][0][0].map  {|(lng,lat)| {"lat"=>lat,"lng"=>lng}}].to_json
  end
  
  def coordinates_hash
    self.coordinates.map {|x| {:lat => x[0], :lng => x[1]}}
  end
end
