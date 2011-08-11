require 'csv'
desc "Import schools from CSV file"
task :import_schools_csv do
  CSV.foreach("#{Rails.root.to_s}/public/schools.csv") do |row|
    school = {
      :name                 => row[0],
      :mail_cluster_id      => MailCluster.find_or_create_by_name(row[1].try(:gsub, /Mail Cluster: /, '')).try(:id),
      :assignment_zone_id   => AssignmentZone.find_or_create_by_name(row[2].try(:gsub, /Assignment Zone: /, '')).try(:id),
      :school_level_id      => SchoolLevel.find_or_create_by_name(row[3]).id,
      :hours                => row[4],
      :breakfast            => row[5],
      :lunch                => row[6],
      :early_dismissal_time => row[7],
      :grades               => row[8],
      :school_group_id      => SchoolGroup.find_or_create_by_name(row[9]).id
    }
    School.create(school)
  end
end