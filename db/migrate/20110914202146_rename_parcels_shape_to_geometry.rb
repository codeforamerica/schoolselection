class RenameParcelsShapeToGeometry < ActiveRecord::Migration
  def up
    rename_column :parcels, :shape, :geometry
  end

  def down
    rename_column :parcels, :geometry, :shape
  end
end
