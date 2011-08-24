class AssignmentZone < ActiveRecord::Base
  has_many :schools
  has_many :coordinates
  
  ####### CLASS METHODS #######
  
  def self.assignment_zones_by_grade_level(grade_level, location)
    if grade_level == 'High School'
      self.all
    else
      self.find_all_with_point(location.lat, location.lng)
    end
  end
    
  def self.find_all_with_point(lat, lng)
    self.all.select {|x| x.includes_point?(lat, lng)}
  end
  
  ####### INSTANCE METHODS #######
  
  def geokitted_coordinates
    # make arrays of lat lng pairs into Geokit objects
    self.coordinates.map {|x| Geokit::LatLng.new(x.lat, x.lng)}
  end
  
  def schools_by_grade_level(grade_level)
    School.find_all_with_school_level(grade_level).select {|x| self.includes_point?(x.lat.to_f, x.lng.to_f) }
  end
  
  def includes_point?(lat, lng)
    polygon = self.geokitted_coordinates
    intersects = 0
    p1 = polygon[0]
    for i in 1..(polygon.size-1)
      p2 = polygon[i % polygon.size]
      if ((lat > [p1.lat,p2.lat].min) &&
        (lat <= [p1.lat,p2.lat].max) &&
        (lng <= [p1.lng,p2.lng].max) &&
        (p1.lat != p2.lat))
        xinters = (lat-p1.lat)*(p2.lng-p1.lng)/(p2.lat-p1.lat)
        p1.lng
        intersects += 1 if (p1.lng == p2.lng || lng <= xinters)
      end
      p1 = p2
    end
    (intersects % 2 == 1)
  end
end
