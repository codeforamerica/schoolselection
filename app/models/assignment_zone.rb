class AssignmentZone < ActiveRecord::Base
  has_many :coordinates
  
  def geokitted_coordinates
    # make arrays of lat lng pairs into Geokit objects
    self.coordinates.map {|x| Geokit::LatLng.new(x.lat, x.lng)}
  end
  
  def self.find_with_point(lat, lng)
    self.all.select {|x| x.includes_point?(lat, lng)}
  end
  
  def schools(grade_level)
    School.school_level_finder(grade_level).select {|x| self.includes_point?(x.lat.to_f, x.lng.to_f) }
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
