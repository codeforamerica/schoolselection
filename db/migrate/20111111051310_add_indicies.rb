class AddIndicies < ActiveRecord::Migration
  def up
    add_index :address_ranges, :geocode_id
    add_index :coordinates, :assignment_zone_id
    add_index :geocode_grade_walkzone_schools, :geocode_id
    add_index :geocode_grade_walkzone_schools, :grade_level_id
    add_index :geocode_grade_walkzone_schools, :school_id
    add_index :geocodes, :assignment_zone_id
    add_index :neighborhoods, :city_id
    add_index :schools, :neighborhood_id
    add_index :schools, :parcel_id
    add_index :schools, :permalink
  end

  def down
    remove_index :address_ranges, :geocode_id
    remove_index :coordinates, :assignment_zone_id
    remove_index :geocode_grade_walkzone_schools, :geocode_id
    remove_index :geocode_grade_walkzone_schools, :grade_level_id
    remove_index :geocode_grade_walkzone_schools, :school_id
    remove_index :geocodes, :assignment_zone_id
    remove_index :neighborhoods, :city_id
    remove_index :schools, :neighborhood_id
    remove_index :schools, :parcel_id
    remove_index :schools, :permalink
  end
end
