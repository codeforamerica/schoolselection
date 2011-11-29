class RemoveUnusedFields < ActiveRecord::Migration
  def up
    remove_column :schools, :breakfast
    remove_column :schools, :lunch
    remove_column :schools, :dinner
    remove_column :schools, :core_areas_teachers_count
    remove_column :schools, :licensed_teachers_percentage
    remove_column :schools, :qualified_teachers_percentage
    remove_column :schools, :qualified_classes_percentage
    remove_column :schools, :school_level_name
    remove_column :schools, :school_type_name
  end

  def down
    add_column :schools, :breakfast, :string
    add_column :schools, :lunch, :string
    add_column :schools, :dinner, :string
    add_column :schools, :core_areas_teachers_count, :string
    add_column :schools, :licensed_teachers_percentage, :string
    add_column :schools, :qualified_teachers_percentage, :string
    add_column :schools, :qualified_classes_percentage, :string
    add_column :schools, :school_level_name, :string
    add_column :schools, :school_type_name, :string
  end
end
