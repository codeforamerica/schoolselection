class GradeLevelHour < ActiveRecord::Base
  belongs_to :grade_level
  belongs_to :school
end
