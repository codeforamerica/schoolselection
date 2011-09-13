class CreateNeighborhoods < ActiveRecord::Migration
  def change
    create_table :neighborhoods do |t|
      t.integer :city_id
      t.string :name
      t.timestamps
    end
  end
end
