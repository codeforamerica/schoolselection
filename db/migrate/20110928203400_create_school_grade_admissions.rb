class CreateSchoolGradeAdmissions < ActiveRecord::Migration
  def change
    create_table :school_grade_admissions do |t|
      t.integer :school_id
      t.integer :grade_level_id
      t.integer :open_seats
      t.integer :first_choice
      t.integer :second_choice
      t.integer :third_choice
      t.integer :fourth_higher_choice
      t.timestamps
    end
    add_index :school_grade_admissions, :school_id
    add_index :school_grade_admissions, :grade_level_id
  end
end
