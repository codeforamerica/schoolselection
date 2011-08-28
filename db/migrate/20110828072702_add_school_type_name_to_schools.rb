class AddSchoolTypeNameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :school_type_name, :string
  end
end
