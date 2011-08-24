class AddAttributesToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :bpsid, :integer
    add_column :schools, :org_code, :integer
    add_column :schools, :teachers_count, :integer
    add_column :schools, :core_areas_teachers_count, :integer
    add_column :schools, :licensed_teachers_percentage, :float
    add_column :schools, :qualified_teachers_percentage, :float
    add_column :schools, :qualified_classes_percentage, :float
    add_column :schools, :staff_to_student_ratio, :float
  end
end
