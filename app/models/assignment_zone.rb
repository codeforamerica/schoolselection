class AssignmentZone < ActiveRecord::Base
  has_many :schools
  
  serialize :coordinates # expects an array of [lat, lng] arrays
  
  # before_save :recalculate_included_schools so if they change the zones the schools will be reindexed TODO
  
  ####### CLASS METHODS #######
  
  def self.find_by_location(location)
    self.where("ST_Intersects(ST_GeomFromText('POINT(#{location.lng} #{location.lat})'), shape)")
  end
  
  def self.citywide
    self.find_by_name('Citywide')
  end
  
  ####### INSTANCE METHODS #######
  
  def coordinates_hash
    self.coordinates.map {|x| {:lat => x[0], :lng => x[1]}}
  end
  
  def schools_by_grade_level(grade_level)
    School.find_all_with_school_level(grade_level).select {|x| self.includes_point?(x.lat.to_f, x.lng.to_f) }
  end
end
