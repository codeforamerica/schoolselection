class CreateGradeLevels < ActiveRecord::Migration
  def change
    create_table :grade_levels do |t|
      t.string :name
      t.float :walk_zone_radius
      t.timestamps
    end
    
    create_table :grade_levels_schools, :id => false do |t|
      t.integer :grade_level_id
      t.integer :school_id
      t.timestamps
    end
  end
end
