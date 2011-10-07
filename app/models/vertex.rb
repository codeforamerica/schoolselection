class Vertex < ActiveRecord::Base
  set_table_name "vertices_tmp"

  class << self
    def nearest_to(location,max_distance=100)
      p = "ST_GeogFromText('POINT(#{location.lng.to_f} #{location.lat.to_f})')"
      where("ST_DWithin(the_geom,#{p},?)",100)
        .order("ST_Distance(the_geom,#{p})")
    end
  end

  def walk_zone(distance)
  end
end