class ConsolidateSchoolGradeJoin < ActiveRecord::Migration
  def up
    drop_table :grade_levels_schools
    rename_table :school_grades, :grade_level_schools
  end

  def down
    rename_table :grade_level_schools, :school_grades
    create_table :grade_levels_schools, :id => false do |t|
      t.integer :grade_level_id
      t.integer :school_id
      t.timestamps
    end
  end
end
