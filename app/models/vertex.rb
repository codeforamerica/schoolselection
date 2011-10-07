class Vertex < ActiveRecord::Base
  set_table_name "vertices_tmp"

  class << self
    def find_nearest(location,max_distance=100)
    end
  end

  def walk_zone(distance)
  end
end