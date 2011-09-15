require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'mechanize'

url = 'http://www.bostonpublicschools.org/view/all-schools-z'
html = Nokogiri::HTML(open(url))

html.css('table.views-view-grid td a').each do |link|
	page = Nokogiri::HTML(open("http://www.bostonpublicschools.org#{link['href']}"))
	unless page.blank?
  	school = School.find_or_create_by_name(page.at_css('h1.title').try(:inner_text).try(:strip))
    school.update_attributes(:description => page.at_css('school-note').try(:inner_html).try(:strip),
      :bpsid              => page.at_css('.field-field-report-card a').inner_text.gsub(/\D/, ''),
      :address            => page.at_css('.vcard .street-address').try(:inner_text).try(:strip),
      :city               => City.find_or_create_by_name(page.at_css('.vcard .locality').try(:inner_text).try(:strip)),
      :state              => State.find_or_create_by_abbreviation(page.at_css('.vcard .region').try(:inner_text).try(:strip)),
      :zipcode            => page.at_css('.vcard .postal-code').try(:inner_text).try(:strip),
      :website            => (page.at_css('.field-field-bps-site-link a')['href'] if page.at_css('.field-field-bps-site-link a').present?),
      :grades             => page.at_css('.field-field-grades').try(:inner_text).try(:strip),    
      :early_dismissal_time => page.at_css('.field-field-early-dismissal').try(:inner_text).try(:strip),    
      :mail_cluster       => MailCluster.find_or_create_by_name(page.at_css('.field-field-mail-cluster').try(:inner_text).try(:strip)),
      :school_level       => SchoolLevel.find_or_create_by_name(page.at_css('.field-field-school-level').try(:inner_text).try(:strip)),
      :assignment_zone    => AssignmentZone.find_or_create_by_name(page.at_css('.field-field-assignment-zone').try(:inner_text).try(:strip)),
      :school_type        => SchoolType.find_or_create_by_name(page.at_css('.field-field-school-type').try(:inner_text).try(:strip).gsub(/School Type: /, '')),
      :school_group       => SchoolGroup.find_or_create_by_name(page.at_css('.field-field-school-group').try(:inner_text).try(:strip)),
      :principal          => Principal.find_or_create_by_first_name_and_last_name(page.at_css('.field-field-principal-name').try(:inner_text).try(:split, ' ').try(:at, 1).try(:at, 2))
    )
  
    school[:lat], school[:lng] = page.at_css('.map-link a')['href'].match(/(\d+\.\d+).*-(\d+\.\d+)/).try(:values_at, 1,2)
  
    school[:start_time], school[:end_time] = page.at_css('.field-field-school-hours').try(:inner_text).match(/(\d{1,2}:\d{2} [ap].m\.) - (\d{1,2}:\d{2} [ap].m\.)/).try(:values_at, 1,2)
  
    page.css(".vcard .tel").each do |tel_div|
      type = {"voice"=>:phone, "fax"=>:fax}[ tel_div.at_css(".type")["title"] ]
      school[type] = tel_div.at_css("span").try(:inner_text)
    end
    school.save
  end
end