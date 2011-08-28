class GradeLevel < ActiveRecord::Base
  has_and_belongs_to_many :schools  
end
