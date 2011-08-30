class RemoveColumnsFromSchoolsThatPointToDeletedModels < ActiveRecord::Migration
  def up
    remove_column :schools, :school_type_id
    remove_column :schools, :school_level_id
  end

  def down
    add_column :schools, :school_type_id, :integer
    add_column :schools, :school_level_id, :integer
  end
end
