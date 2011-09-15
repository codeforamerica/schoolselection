class CreateParcels < ActiveRecord::Migration
  def up
    remove_index :schools, :parcel
    remove_column :schools, :parcel
    add_column :schools, :parcel_id, :integer
    
    create_table :parcels do |t|
      t.geometry :shape, :geographic => true
      t.string :build_name
      t.string :address
      t.integer :city_id
      t.string :zipcode
      t.timestamps
    end
    add_index :parcels, :shape, :spatial => true
  end
  
  def down
    remove_column :schools, :parcel_id
    add_column :schools, :parcel, :geometry, :geographic => true
    add_index :schools, :parcel, :spatial => true
    drop_table :parcels
    drop_table :parcels_schools
  end
end
