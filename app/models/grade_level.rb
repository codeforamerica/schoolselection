class GradeLevel < ActiveRecord::Base
  has_many :grade_level_schools
  has_many :schools, :through => :grade_level_schools
  
  def assignment_zone_schools(geocoded_address, assignment_zone)
    schools = self.schools.where(:assignment_zone_id => assignment_zone)
      .select("schools.*")
      .with_distance(geocoded_address)
      .includes(:grade_level_schools, :city)
      .order('distance ASC')
    [[schools,"Assignment Zone",2]].each do |schools,type,index|
      schools.each do |s|
        s.eligibility = type
        s.eligibility_index = index
      end
    end
    schools
  end
  
  def citywide_schools(geocoded_address, assignment_zone)
    schools = self.schools.where(:assignment_zone_id => assignment_zone)
      .select("schools.*")
      .with_distance(geocoded_address)
      .includes(:grade_level_schools, :city)
      .order('distance ASC')
    [[schools,"Citywide",3]].each do |schools,type,index|
      schools.each do |s|
        s.eligibility = type
        s.eligibility_index = index
      end
    end
    schools
  end

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
    self.all.sort_by(&:order_index).slice_before {|x| !as_i.include?(x.order_index-1)}.map {|arr| "#{arr.first.number}-#{arr.last.number}"}*", "
  end
end
