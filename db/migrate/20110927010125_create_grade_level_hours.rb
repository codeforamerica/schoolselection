class CreateGradeLevelHours < ActiveRecord::Migration
  def change
    create_table :grade_level_hours do |t|
      t.integer :grade_level_id
      t.integer :school_id
      t.string  :grade_level_number
      t.string  :hours
      t.timestamps
    end
    add_index :grade_level_hours, :grade_level_id
    add_index :grade_level_hours, :school_id
  end
end
