class RemoveGradesFromSchools < ActiveRecord::Migration
  def up
    remove_column :schools, :grades
  end

  def down
    add_column :schools, :grades, :string
  end
end
