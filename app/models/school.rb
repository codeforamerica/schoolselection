class School < ActiveRecord::Base
  belongs_to :assignment_zone
  belongs_to :city
  belongs_to :mail_cluster
  belongs_to :principal
  belongs_to :school_group
  belongs_to :school_level
  belongs_to :school_type
  belongs_to :state
  
  # before_save :fix_times

  def fix_times
    self.updated_at = updated_at.to_time
    self.created_at = created_at.to_time
  end
end
