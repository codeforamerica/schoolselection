class RemoveHoursFromSchools < ActiveRecord::Migration
  def up
    remove_column :schools, :hours
  end

  def down
    add_column :schools, :hours, :string
  end
end
