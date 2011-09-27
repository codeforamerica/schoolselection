class GradeLevel < ActiveRecord::Base
  has_and_belongs_to_many :schools
  has_many :grade_level_hours

  def walk_zone_radius_in_meters
    self.walk_zone_radius * METERS_PER_MILE
  end

  def order_index
    #currently, grades are K0,K1,K2,1,2,...
    #this function will give us a canonical ordering, where K0=0,K2=2,1=3, ... 
    number =~ /K(\d)/ ? $1.to_i : (number.to_i + 2)
  end

  def self.short_string #not sure if this should go in here or not
    as_i = self.all.map(&:order_index).sort
    self.all.slice_before {|x| !as_i.include?(x.order_index-1)}.map {|arr| "#{arr.first.number}-#{arr.last.number}"}*", "
  end
end
