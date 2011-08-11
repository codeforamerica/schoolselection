class CreateSchoolTypes < ActiveRecord::Migration
  def change
    create_table :school_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
