class RemoveSchoolsLatitudeAndLongitude < ActiveRecord::Migration
  def up
    remove_column :schools, :latitude
    remove_column :schools, :longitude
  end

  def down
    add_column :schools, :latitude, :float
    add_column :schools, :longitude, :float
  end
end
