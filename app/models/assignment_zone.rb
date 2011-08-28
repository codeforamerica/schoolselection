class AssignmentZone < ActiveRecord::Base
  has_many :schools
  # has_many :coordinates
  
  serialize :coordinates
  
  ####### CLASS METHODS #######
  
  def self.find_all_with_location_and_grade_level(location, grade_level)
    if grade_level.name == 'High'
      self.all
    else
      self.find_all_with_point(location.lat, location.lng)
    end
  end
    
  def self.find_all_with_point(lat, lng)
    self.all.select {|x| x.includes_point?(lat, lng)}
  end
  
  ####### INSTANCE METHODS #######
  
  def coordinates_hash
    self.coordinates.map {|x| {:lat => x[0], :lng => x[1]}}
  end
  
  def schools_by_grade_level(grade_level)
    School.find_all_with_school_level(grade_level).select {|x| self.includes_point?(x.lat.to_f, x.lng.to_f) }
  end
  
  def includes_point?(lat, lng)
    polygon = self.coordinates
    if polygon.blank?
      return false
    else
      intersects = 0
      p1 = polygon[0]
      for i in 1..(polygon.size-1)
        p2 = polygon[i % polygon.size]
        if ((lat > [p1[0],p2[0]].min) &&
          (lat <= [p1[0],p2[0]].max) &&
          (lng <= [p1[1],p2[1]].max) &&
          (p1[0] != p2[0]))
          xinters = (lat-p1[0])*(p2[1]-p1[1])/(p2[0]-p1[0])
          p1[1]
          intersects += 1 if (p1[1] == p2[1] || lng <= xinters)
        end
        p1 = p2
      end
      (intersects % 2 == 1)
    end
  end
end
