class CreateSchoolGrades < ActiveRecord::Migration
  def change
    create_table :school_grades do |t|
      t.integer :school_id
      t.integer :grade_level_id
      t.string :grade_number
      t.string :hours
      t.integer :open_seats
      t.integer :first_choice
      t.integer :second_choice
      t.integer :third_choice
      t.integer :fourth_higher_choice
      t.integer :mcas_reading
      t.integer :mcas_math
      t.timestamps
    end
    add_index :school_grades, :school_id
    add_index :school_grades, :grade_level_id
  end
end
