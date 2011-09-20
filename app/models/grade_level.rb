class GradeLevel < ActiveRecord::Base
  has_and_belongs_to_many :schools

  def walk_zone_radius_in_meters
    self.walk_zone_radius * MILES_TO_METERS
  end

end
