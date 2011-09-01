class GradeLevel < ActiveRecord::Base
  has_and_belongs_to_many :schools
  
  def walk_zone_schools(address)
    radius_in_feet = self.walk_zone_radius * 5280
    self.schools.where("ST_DWithin(parcel, ST_Transform(ST_GeomFromText('POINT(#{address.lng} #{address.lat})', 4326), 2249), #{radius_in_feet})")
  end
  
  def assignment_zone_schools(location, assignment_zones)
    if self.name == 'High'
      [] # all high schools should show up as citywide schools, not assignment zone schools
    else  
      assignment_zone_ids = assignment_zones.map {|x| x.id}
      self.schools.where("ST_DWithin(parcel, ST_Transform(ST_GeomFromText('POINT(#{address.lng} #{address.lat})', 4326), 2249), #{radius_in_feet})")
    end
  end
end
