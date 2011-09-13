class City < ActiveRecord::Base
  has_many :schools
  has_many :neighborhoods
end
