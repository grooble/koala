require 'koala'
require 'json'
require 'fileutils'

oauth_access_token = "EAACEdEose0cBAKfbBZBm3lMxCWj8khnIAaagRCj1R21rkKUj6ncEsmydhA4RcXYIL57BqZCFf2NbHbfkIo3sUrkeZAx7hE3pl4yfYfPbCPHxwX0ueAHpuU3yuMmqlQoxyFuWZANZCVTXMtAXJBCdd1z43EdKj7iPEBUkUWm9HFcTMWlYDrtJI"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\records3.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")

y_response = @graph.get_connection('431753333699609_596523277222613','sharedposts',{
                                   fields: ['message', 'id', 'story', 'created_time']
								   })
puts y_response.length
							
y_response.each do |post|
    puts "ID: #{post["id"]};\n MSG: #{post["message"]};\n STORY: #{post["story"]};\n CREATED: #{post["created_time"]}"
	f.puts "ID: #{post["id"]};\n MSG: #{post["message"]};\n STORY: #{post["story"]};\n CREATED: #{post["created_time"]}" 
	f.puts
end
f.close