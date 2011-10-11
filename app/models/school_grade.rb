class SchoolGrade < ActiveRecord::Base
  belongs_to :school
  belongs_to :grade_level
  
  def total_choices
    if first_choice.present?
      total = 0
      total += first_choice
      total += second_choice
      total += third_choice
      total += fourth_higher_choice
      total
    end
  end
  
  def demand
    if total_choices.present?
      (total_choices.to_f / open_seats) * 100
    end
  end
end
