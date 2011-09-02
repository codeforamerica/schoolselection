class GradeLevel < ActiveRecord::Base
  has_and_belongs_to_many :schools
  
  def assignment_zone_schools(location, assignment_zone)
    if self.name == 'High'
      [] # all high schools should show up as citywide schools, not assignment zone schools
    else  
      assignment_zone_ids = assignment_zones.map {|x| x.id}
      self.schools.where(:assignment_zone => assignment_zone)
    end
  end
end
