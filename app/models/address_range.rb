class AddressRange < ActiveRecord::Base
  belongs_to :geocode

  class << self
    def find_by_address(num,street_name,zipcode)
      where(:street=>street_name.upcase.strip, :zipcode=>zipcode, :is_even=>num.even?).where("num_start <= ? AND num_end >= ?",num,num)
    end
  end
end