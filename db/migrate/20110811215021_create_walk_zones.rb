class CreateWalkZones < ActiveRecord::Migration
  def change
    create_table :walk_zones do |t|
      t.string :name
      t.decimal :distance

      t.timestamps
    end
    create_table :schools_walk_zones, :id => false do |t|
      t.integer :walk_zone_id
      t.integer :school_id
    end
    create_table :school_levels_walk_zones, :id => false do |t|
      t.integer :walk_zone_id
      t.integer :school_level_id
    end
  end
end
