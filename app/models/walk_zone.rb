class WalkZone < ActiveRecord::Base
  has_and_belongs_to_many :schools, :order => 'name'
  has_and_belongs_to_many :school_levels
end
