class CreatePrincipals < ActiveRecord::Migration
  def change
    create_table :principals do |t|
      t.string :first_name
      t.string :last_name
      t.string :titles
      t.text :biography

      t.timestamps
    end
  end
end
