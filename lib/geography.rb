module Geography
    
  def geocode_address(address)
    boston = Geokit::Geocoders::GoogleGeocoder.geocode('Boston, MA')
    address = Geokit::Geocoders::GoogleGeocoder.geocode(address, :bias => boston.suggested_bounds)
    # Geokit::Geocoders::MultiGeocoder.geocode(address)
  end

  def walkshed_for_point(vertex,radius_in_km)
    result = ActiveRecord::Base.connection.execute("select the_geom from points_as_polygon($$select vertex_id as id, ST_X(geometry(the_geom)) as x, ST_Y(geometry(the_geom)) as y from driving_distance(''SELECT gid as id, source, target, length as cost from ways where class_id >= 104'',#{vertex.id.to_i},#{radius_in_km.to_f}, false,false) join vertices_tmp on vertices_tmp.id = vertex_id$$);")
    result[0]["the_geom"]
  end

  #returns a hash of vertex_id=>driving_distance
  def driving_distances_for_point(vertex,max_distance=25.0)
    result = ActiveRecord::Base.connection.execute("select vertex_id, cost from driving_distance('SELECT gid as id, source, target, length as cost from ways',#{vertex.id.to_i},#{max_distance.to_f}, false,false) where vertex_id in (select vertex_id from schools);")
    Hash[result.map do |h|
      [h["vertex_id"].to_i, h["cost"].to_f]
    end]
  end
end