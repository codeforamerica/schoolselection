class AddMcasDataToSchoolGrades < ActiveRecord::Migration
  def change
    remove_column :school_grades, :mcas_reading
    remove_column :school_grades, :mcas_math
    add_column :school_grades, :mcas_ela_total, :integer
    add_column :school_grades, :mcas_ela_advanced, :float
    add_column :school_grades, :mcas_ela_proficient, :float
    add_column :school_grades, :mcas_ela_needsimprovement, :float
    add_column :school_grades, :mcas_ela_failing, :float
    add_column :school_grades, :mcas_math_total, :integer
    add_column :school_grades, :mcas_math_advanced, :float
    add_column :school_grades, :mcas_math_proficient, :float
    add_column :school_grades, :mcas_math_needsimprovement, :float
    add_column :school_grades, :mcas_math_failing, :float
    add_column :school_grades, :mcas_science_total, :integer
    add_column :school_grades, :mcas_science_advanced, :float
    add_column :school_grades, :mcas_science_proficient, :float
    add_column :school_grades, :mcas_science_needsimprovement, :float
    add_column :school_grades, :mcas_science_failing, :float
  end
end
