class Geocode < ActiveRecord::Base
  has_many :address_ranges
  has_many :geocode_grade_walkzone_schools, :dependent => :destroy
  belongs_to :assignment_zone

end