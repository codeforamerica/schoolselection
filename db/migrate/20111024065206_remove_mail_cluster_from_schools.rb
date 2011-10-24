class RemoveMailClusterFromSchools < ActiveRecord::Migration
  def up
    remove_column :schools, :mail_cluster_id
  end

  def down
    add_column :schools, :mail_cluster_id, :integer
  end
end
