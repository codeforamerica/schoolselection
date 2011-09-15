class RemoveSpatialIndexFromParcels < ActiveRecord::Migration
  def up
    remove_index :parcels, :shape
  end

  def down
    add_index :parcels, :shape, :spatial => true
  end
end
