class City < ActiveRecord::Base
  belongs_to :state
  has_many :schools
  has_many :neighborhoods
end
