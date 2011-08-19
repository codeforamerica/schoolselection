class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.integer :assignment_zone_id
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
