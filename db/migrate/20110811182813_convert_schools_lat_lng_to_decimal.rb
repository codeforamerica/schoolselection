class ConvertSchoolsLatLngToDecimal < ActiveRecord::Migration
  def up
    add_column :schools, :latitude, :decimal
    add_column :schools, :longitude, :decimal
  end

  def down
    remove_column :schools, :latitude
    remove_column :schools, :longitude
  end
end
