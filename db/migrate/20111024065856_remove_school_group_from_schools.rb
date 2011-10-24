class RemoveSchoolGroupFromSchools < ActiveRecord::Migration
  def up
    remove_column :schools, :school_group_id
  end

  def down
    add_column :schools, :school_group_id, :integer
  end
end
