class RemoveOrgcodeFromSchools < ActiveRecord::Migration
  def up
    remove_column :schools, :orgcode
  end

  def down
    add_column :schools, :orgcode, :string
  end
end
