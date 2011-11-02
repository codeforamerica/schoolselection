class GeocodeGradeWalkzoneSchool < ActiveRecord::Base
  belongs_to :geocode
  belongs_to :grade_level
  belongs_to :school
end