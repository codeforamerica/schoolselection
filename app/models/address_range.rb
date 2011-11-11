class AddressRange < ActiveRecord::Base
  belongs_to :geocode

  ABBR = ["AL", "AV", "BL", "BLK", "BRG", "BRK", "CI", "CIR", "CR", "CT", "CTR", "ENT", "EST", "EX", "EXT", "FLD", "FRN", "FT", "GR", "GRN", "HLL", "HTS", "HWY", "ISL", "LN", "NTL", "ON", "PK", "PL", "PT", "PTH", "RD", "RMP", "ROW", "RVR", "SO", "SQ", "TE", "TER", "TPK", "TR", "VL", "WF", "WHF", "WY", "YD"]
  
  class << self
    def find_all_by_search_params(num,street_name,zipcode)
      street_name = street_name.upcase
      results = self.where("street = ? AND num_start <= ? AND num_end >= ? AND is_even = ?",street_name,num,num,num.even?)
      
      # if we can't find the address using a literal search, use the street matcher
      if results.blank?
        words = street_name.upcase.strip.split
        ignored_words,search_words = words.partition {|w| ABBR.include? w}
        street_matcher = '[[:<:]](' + search_words*"|" + ')[[:>:]]'
        results = self.where("street ~ ? AND num_start <= ? AND num_end >= ? AND is_even = ?",street_matcher,num,num,num.even?)
      end

      #if we have multiple possibilities, try to filter by zipcode
      if results.length > 1 && zipcode.strip =~ /^\d{5}$/
        results = results.select {|x| x.zipcode == zipcode.strip}
      end

      #if we still have multiple possibilities, try to add in the ignored words, if we have any
      if results.length > 1 && ignored_words.length > 1
        street_matcher = '[[:<:]](' + words*"|" + ')[[:>:]]'
        results = self.where("street ~ ? AND num_start <= ? AND num_end >= ? AND is_even = ?",street_matcher,num,num,num.even?)
        #and filter again by zipcode, perhaps
        if geo_ids.length > 1 && zipcode.strip =~ /^\d{5}$/
          results = results.select {|x| x.zipcode == zipcode.strip}
        end
      end
      
      return results
      
    end
  end
end