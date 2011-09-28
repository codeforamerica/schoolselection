class SchoolGradeAdmission < ActiveRecord::Base
  belongs_to :school
  belongs_to :grade_level
  
  def total_choices
    total = 0
    total += first_choice if first_choice.present?
    total += second_choice if second_choice.present?
    total += third_choice if third_choice.present?
    total += fourth_higher_choice if fourth_higher_choice.present?
    return total
  end
end
