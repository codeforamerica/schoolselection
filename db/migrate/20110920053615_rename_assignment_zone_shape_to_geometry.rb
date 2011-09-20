class RenameAssignmentZoneShapeToGeometry < ActiveRecord::Migration
  def up
    rename_column :assignment_zones, :shape, :geometry
  end

  def down
    rename_column :assignment_zones, :geometry, :shape
  end
end
