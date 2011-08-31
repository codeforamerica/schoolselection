class AddParcelCoordinatesToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :parcel, :polygon
    add_index :schools, :parcel, :spatial => true
  end
end
