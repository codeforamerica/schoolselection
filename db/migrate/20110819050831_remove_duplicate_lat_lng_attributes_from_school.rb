class RemoveDuplicateLatLngAttributesFromSchool < ActiveRecord::Migration
  def up
    remove_column :schools, :lat
    remove_column :schools, :lng
    add_column :schools, :lat, :float
    add_column :schools, :lng, :float
  end
end
