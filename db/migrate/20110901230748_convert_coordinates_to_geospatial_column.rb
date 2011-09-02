class ConvertCoordinatesToGeospatialColumn < ActiveRecord::Migration
  def up
    remove_column :assignment_zones, :coordinates
    add_column :assignment_zones, :shape, :multi_polygon, :srid => 4326
    add_index :assignment_zones, :shape, :spatial => true
  end

  def down
    remove_column :assignment_zones, :shape
    remove_index :assignment_zones, :shape
    add_column :assignment_zones, :coordinates, :text
  end
end
