class AddUniformPolicyToGradeLevelSchools < ActiveRecord::Migration
  def change
    add_column :grade_level_schools, :uniform_policy, :text
  end
end
