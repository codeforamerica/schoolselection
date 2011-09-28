class State < ActiveRecord::Base
  has_many :schools
  has_many :cities
end
