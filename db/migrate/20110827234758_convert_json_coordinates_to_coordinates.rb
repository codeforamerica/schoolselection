class ConvertJsonCoordinatesToCoordinates < ActiveRecord::Migration
  def up
    rename_column :assignment_zones, :json_coordinates, :coordinates
  end

  def down
    rename_column :assignment_zones, :coordinates, :json_coordinates
  end
end
