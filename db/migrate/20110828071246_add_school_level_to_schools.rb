class AddSchoolLevelToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :school_level_name, :string
  end
end
