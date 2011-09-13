class MakeZoneCoordiantesGeo < ActiveRecord::Migration
  def up
    remove_column :assignment_zones, :coordinates
    add_column :assignment_zones, :shape, :geometry, :geographic => true
  end

  def down
    raise "write me"
  end
end
