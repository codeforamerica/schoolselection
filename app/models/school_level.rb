class SchoolLevel < ActiveRecord::Base
  
  has_and_belongs_to_many :walk_zones
  has_many :schools
  
  
  def self.ids_by_walk_zone_distance(distance)
    ids = []
    self.all.map {|level| ids << level.id if level.walk_zone_distances.include?(distance.to_s) }
    ids.uniq
  end
end
