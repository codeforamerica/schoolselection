class ChangeGradeLevelNameAndNumber < ActiveRecord::Migration
  def up
    rename_column :grade_levels, :name, :number
    add_column :grade_levels, :name, :string
  end

  def down
    remove_column :grade_levels, :name
    rename_column :grade_levels, :number, :name
  end
end
