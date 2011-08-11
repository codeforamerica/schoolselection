class CreateSchoolGroups < ActiveRecord::Migration
  def change
    create_table :school_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
