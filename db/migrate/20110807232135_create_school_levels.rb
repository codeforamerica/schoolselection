class CreateSchoolLevels < ActiveRecord::Migration
  def change
    create_table :school_levels do |t|
      t.string :name

      t.timestamps
    end
  end
end
