class SchoolGrade < ActiveRecord::Base
  belongs_to :school
  belongs_to :grade_level
end
