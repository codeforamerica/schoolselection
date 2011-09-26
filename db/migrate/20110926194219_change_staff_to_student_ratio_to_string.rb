class ChangeStaffToStudentRatioToString < ActiveRecord::Migration
  def up
    change_column :schools, :staff_to_student_ratio, :string
  end

  def down
    change_column :schools, :staff_to_student_ratio, :float
  end
end
