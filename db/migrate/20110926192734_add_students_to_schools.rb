class AddStudentsToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :students_count, :integer
  end
end
