class AddGeographicParcelToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :parcel, :geometry, :geographic => true
    add_index :schools, :parcel, :spatial => true
  end
end
