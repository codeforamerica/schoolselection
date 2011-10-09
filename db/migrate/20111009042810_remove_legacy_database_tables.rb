class RemoveLegacyDatabaseTables < ActiveRecord::Migration
  def up
    drop_table :mail_clusters
    drop_table :grade_level_hours
    drop_table :school_grade_admissions
  end

  def down
    create_table :mail_clusters do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :grade_level_hours do |t|
      t.integer :grade_level_id
      t.integer :school_id
      t.string  :grade_level_number
      t.string  :hours
      t.timestamps
    end
    add_index :grade_level_hours, :grade_level_id
    add_index :grade_level_hours, :school_id
    
    create_table :school_grade_admissions do |t|
      t.integer :school_id
      t.integer :grade_level_id
      t.integer :open_seats
      t.integer :first_choice
      t.integer :second_choice
      t.integer :third_choice
      t.integer :fourth_higher_choice
      t.timestamps
    end
    add_index :school_grade_admissions, :school_id
    add_index :school_grade_admissions, :grade_level_id
  end
end
