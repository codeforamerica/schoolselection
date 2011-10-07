class AddVertexToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :vertex_id, :integer
  end
end
