require 'csv'

#load address ranges
cols = %w(FromAddr ToAddr FromX ToX FromY ToY OddEven Street Zip HZone HDistrict GeoCode NhCode Fileid lastupdatedate lastupdateaction lastupdateuserid)
CSV.foreach("export/export/addrFil.csv") do |r|
  row = Hash[cols.zip(r)]
  #todo: check for existence
  AddressRange.create(
    :num_start=>row["FromAddr"].to_i,
    :num_end => row["ToAddr"].to_i,
    :is_even => row["OddEven"] == "2",
    :street  => row["Street"].upcase.strip,
    :zipcode => row["Zip"].strip,
    :geocode => Geocode.find_or_create_by_id(row["GeoCode"].to_i)
  )
end
AddressRange.find_by_street("BURGESS FTWY").destroy #doesn't seem to be a real record.

cols = %w(SchYear Geo HZone HDist LastUpdate LastUpdateAction LastUpdateUserID)
zones = Hash[AssignmentZone.all.map {|a| [a.name.first,a]}]
CSV.foreach("export/export/GeoHZone.csv") do |r|
  row = Hash[cols.zip(r)]
  next unless row["SchYear"] == "2011"
  Geocode.find_or_create_by_id(row["Geo"].to_i).update_attribute(:assignment_zone,zones[row["HZone"]])
end

cols = %w(SchYear Geo SchLevel Sch LastUpdate LastUpdateAction LastUpdateUserId)
grade_tiers = GradeLevel.all.group_by {|g| g.name.first}
grade_tiers["K1"] = GradeLevel.find_all_by_number("K1")
CSV.foreach("export/export/AssignmentWalk.csv") do |r|
  row = Hash[cols.zip(r)]
  next unless row["SchYear"] == "2011"
  grade_tiers[row["SchLevel"].strip.first].each do |grade|
    GeocodeGradeWalkzoneSchool.create(
      :transportation_eligible => true,
      :geocode => Geocode.find(row["Geo"]),
      :grade_level => grade,
      :school => School.find_by_bpsid(row["Sch"])
    )
  end
end

cols = %w(SchYear VersionNo Sch Geo GradeLevel LastUpdate LastUpdateAction LastUpdateUserId)
CSV.foreach("export/export/WalkEligible.csv") do |r|
  row = Hash[cols.zip(r)]
  next unless row["SchYear"] == "2011"
  school = School.find_by_bpsid(row["Sch"])
  next unless school #some bpsids given are invalid!
  grade_tiers[row["GradeLevel"].strip].each do |grade|
    ggws = GeocodeGradeWalkzoneSchool.where(
      :geocode_id => row["Geo"].to_i,
      :grade_level_id => grade.id,
      :school_id => school.id).first
    if ggws
      ggws.update_attribute(:transportation_eligible,false)
    else
      GeocodeGradeWalkzoneSchool.create(
        :transportation_eligible => false,
        :geocode_id => row["Geo"].to_i,
        :grade_level_id => grade.id,
        :school_id => school.id)
    end
  end
end
