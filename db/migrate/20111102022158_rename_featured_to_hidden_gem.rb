class RenameFeaturedToHiddenGem < ActiveRecord::Migration
  def up
    rename_column :schools, :featured, :hidden_gem
  end

  def down
    rename_column :schools, :hidden_gem, :featured
  end
end
