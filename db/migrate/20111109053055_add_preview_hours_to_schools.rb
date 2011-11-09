class AddPreviewHoursToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :preview_hours, :text
  end
end
