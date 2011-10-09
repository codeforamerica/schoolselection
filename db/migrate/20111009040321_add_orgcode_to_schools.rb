class AddOrgcodeToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :orgcode, :string
  end
end
