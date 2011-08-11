class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.text :description
      t.text :features
      t.string :address
      t.integer :city_id
      t.integer :state_id
      t.string :zipcode
      t.string :lat
      t.string :lng
      t.string :phone
      t.string :fax
      t.string :website
      t.integer :assignment_zone_id
      t.integer :school_type_id
      t.integer :mail_cluster_id
      t.integer :school_group_id
      t.integer :school_level_id
      t.string :grades
      t.string :hours
      t.string :early_dismissal_time
      t.string :breakfast
      t.string :lunch
      t.string :dinner
      t.integer :principal_id

      t.timestamps
    end
    add_index :schools, :assignment_zone_id
    add_index :schools, :school_type_id
    add_index :schools, :mail_cluster_id
    add_index :schools, :school_group_id
    add_index :schools, :school_level_id
    add_index :schools, :principal_id
  end
end
