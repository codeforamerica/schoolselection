class AddParcelCoordinatesToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :parcel_coordinates, :text
  end
end
