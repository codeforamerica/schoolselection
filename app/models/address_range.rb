class AddressRange < ActiveRecord::Base
  belongs_to :geocode

  ABBR = ["AL", "AV", "BL", "BLK", "BRG", "BRK", "CI", "CIR", "CR", "CT", "CTR", "ENT", "EST", "EX", "EXT", "FLD", "FRN", "FT", "GR", "GRN", "HLL", "HTS", "HWY", "ISL", "LN", "NTL", "ON", "PK", "PL", "PT", "PTH", "RD", "RMP", "ROW", "RVR", "SO", "SQ", "TE", "TER", "TPK", "TR", "VL", "WF", "WHF", "WY", "YD"]
  class << self
    def geocode_by_address(num,street_name,zipcode)
      words = street_name.upcase.strip.split
      ignored_words,search_words = words.partition {|w| ABBR.include? w}
      street_matcher = '[[:<:]](' + search_words*"|" + ')[[:>:]]'
      res = self.where("street ~ ? AND num_start <= ? AND num_end >= ? AND is_even = ?",street_matcher,num,num,num.even?)
      geo_ids = res.map(&:geocode_id).uniq

      #if we have multiple possibilities, try to filter by zipcode
      if geo_ids.length > 1 && zipcode.strip =~ /^\d{5}$/
        geo_ids = res.select {|x| x.zipcode == zipcode.strip}.map(&:geocode_id).uniq
      end

      #if we still have multiple possibilities, try to add in the ignored words, if we have any
      if geo_ids.length > 1 && ignored_words.length > 1
        street_matcher = '[[:<:]](' + words*"|" + ')[[:>:]]'
        res = self.where("street ~ ? AND num_start <= ? AND num_end >= ? AND is_even = ?",street_matcher,num,num,num.even?)
        geo_ids = res.map(&:geocode_id).uniq
        #and filter again by zipcode, perhaps
        if geo_ids.length > 1 && zipcode.strip =~ /^\d{5}$/
          geo_ids = res.select {|x| x.zipcode == zipcode.strip}.map(&:geocode_id).uniq
        end
      end


      if geo_ids.length == 1
        Geocode.find_by_id(geo_ids.first)
      else
        nil
      end
    end
  end
end