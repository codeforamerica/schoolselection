class AddCoordinatesJsonToAssignmentZones < ActiveRecord::Migration
  def change
    add_column :assignment_zones, :json_coordinates, :text
  end
end
