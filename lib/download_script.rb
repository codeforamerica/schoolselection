# require 'net/http'
# $download_existing = false
# $view_command = "open"
# $come_back_to = []
# 
# urls = File.open("saved_emails") do |f|
#   f.lines.select {|x| x=~/http:\/\/dl.dropbox/}.map(&:chomp)
# end
# 
# zones = Hash[AssignmentZone.all.map {|z| [z.name,z]}]
# zones["High Schools"] = zones["Citywide"]
# 
# #finds a school, prompting for user help. returns a school, or nil if no acceptable match is found.
# def interactive_find_school(zone,school_name)
#   search_term = school_name
#   candidate_matches = zone.schools.where("lower(name) like ?","%#{search_term.downcase}%")
#   last_action = :search
#   until candidate_matches.length == 1
#     puts "error with school name #{school_name}"
#     #puts the header reason for why we're not good.
#     if candidate_matches.empty?
#       if last_action == :search
#         puts "no matches for '#{search_term}' in the #{zone.name} zone. choose an action:"
#       elsif last_action == :new_id
#         puts "no school with that id found"
#       else
#         puts "unknown error"
#       end
#     elsif candidate_matches.length > 1
#       if last_action == :search
#         puts "there were #{candidate_matches.length} matches for '#{search_term}' in the #{zone.name} zone. choose an action:"
#       else
#         puts "unknown error."
#       end
#     end
# 
#     #give them options
#     puts "1) change search term"
#     puts "2) enter school id manually"
#     puts "3) skip this school"
#     #including selecting an existing match
#     candidate_matches.each_with_index do |school,i|
#       puts "#{i+4}) choose: #{school.name}#{' (has existing image)' if school.image?}"
#     end
# 
#     choice = gets.chomp.to_i
#     case choice
#       when 1
#         last_action = :search
#         puts "new term: "
#         search_term = gets.chomp
#         candidate_matches = zone.schools.where("lower(name) like ?","%#{search_term.downcase}%")
#       when 2
#         last_action = :new_id
#         puts "school id: "
#         id = gets.chomp
#         candidate_matches = [School.find(id)] rescue []
#       when 3
#         return nil
#       when (4..(4+candidate_matches.length-1))
#         return candidate_matches[choice-4]
#       else
#         puts "unknown action"
#     end
# 
#   end
# 
#   return candidate_matches[0]
# end
# 
# def download_url_to_school(school,parsed)
#   f = Tempfile.open("school_download",:encoding => 'ascii-8bit')
#   f << Net::HTTP.get(parsed)
#   f.close
#   f2 = File.open(f.path)
#   f2.extend(Paperclip::Upfile) #pretend we're an uploaded file
#   class << f2
#     attr_accessor :original_filename
#   end
#   f2.original_filename = school.name.gsub(/\s/,'_')+".jpg"
#   school.image = f2
#   school.save
# end
# 
# #------------
# 
# by_school_name = urls.group_by do |u|
#   parsed = URI.parse(u)
#   zone_name = URI.unescape(parsed.path.split("/")[-2])
#   parts = URI.unescape(parsed.path.split("/").last.sub(/\.jpg/i,'')).split(/\s+/)
#   school_name = (parts.first.length > 2) ? parts.first : parts.max_by(&:length)
#   [zone_name,school_name]
# end
# 
# by_school_name.each_with_index do |((zone_name,school_name),school_urls),i|
#   puts "processing #{school_name} (#{i+1}/#{by_school_name.length}). urls = #{school_urls.inspect}"
#   zone = zones[zone_name]
# 
#   school = interactive_find_school(zone,school_name)
#   next unless school
#   next if school.image? unless $download_existing
# 
#   # u = if school_urls.length > 1
#   #   while true
#   #     puts "there are multiple images for #{school_name}. choose an action:"
#   #     puts "v) view all"
#   #     puts "v <num>) view number <num>"
#   #     puts "c <num>) choose number <num>"
#   #     puts "s <num>) split off url <num>, and come back to it later. it's for a different school."
#   #     puts "-"*10
#   #     school_urls.each_with_index do |url,i|
#   #       puts "#{i+1}) #{url}"
#   #     end
#   #     action = gets.chomp
#   #     case action
#   #       when /v$/
#   #         system($view_command,*school_urls)
#   #       when /v\s*(\d+)/
#   #         system($view_command,school_urls[$1.to_i-1])
#   #       when /c\s*(\d+)/
#   #         url = school_urls[$1.to_i-1]
#   #         break url if url
#   #       when /s\s*(\d+)/
#   #         $come_back_to <<  school_urls.delete_at($1.to_i-1)
#   #       else
#   #         puts "unknown_command"
#   #     end
#   #   end
#   # else
#     u = school_urls.first
#   # end
#   parsed = URI.parse(u)
# 
#   puts "found #{school.name}. downloading image . . "
# 
#   #download the file, attach it to the school
#   #this is ugly.
#   download_url_to_school(school,parsed)
# end
# 
# puts "-"*10
# puts "main urls done"
# puts "you have #{$come_back_to.length} urls to identify"
# 
# $come_back_to.each do |u|
#   parsed = URI.parse(u)
#   puts "what is school id for #{u}?"
#   id = gets.chomp
#   school = School.find(id)
#   download_url_to_school(school,parsed)
# end