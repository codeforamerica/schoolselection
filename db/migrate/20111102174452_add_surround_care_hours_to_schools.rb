class AddSurroundCareHoursToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :surround_care_hours, :text
  end
end
