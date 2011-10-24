class AddFeaturedToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :featured, :boolean, :default => false
  end
end
