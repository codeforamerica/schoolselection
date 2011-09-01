class AddParcelCoordinatesToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :parcel, :multi_polygon, :srid => 2249
    add_index :schools, :parcel, :spatial => true
  end
end
