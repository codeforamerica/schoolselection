class AddExamSchoolDesignationToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :special_admissions, :boolean, :default => false
  end
end
