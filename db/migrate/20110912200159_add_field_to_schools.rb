class AddFieldToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :short_name, :string
    add_column :schools, :neighborhood_id, :integer
  end
end
