require 'koala'
require 'json'
require 'fileutils'
require 'date'

oauth_access_token = "EAACEdEose0cBAIj1iUPNxna3ndoBHorV9DiZCdaVodFloP0ZBPmubd0MPCX5rURRIEjQDOlfuv9uwBRRfx9asmTPQ7yg2nAPZAvRGYYKs3ehYr9BGj5ZAOISqomVDdZAYQKlRmywbN23vBdPYxvpf18alZBoftlphzoOhtYt03DxCQiSDK9gUy"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\records_4.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
cuttoff = DateTime.new(2016,10,1)
created_time = DateTime.new(2016,12,10)
counter = 0						

y_response = @graph.get_connection('YANMAR.Global.Official','posts',
								{fields: ['message', 'id', 'from', 'type', 'properties', 'link', 'shares', 'likes', 'created_time', 'updated_time']
								})

while created_time > cuttoff do
	y_response.each do |post|
		counter += 1
		puts "ID: #{post["id"]};\n" + 
              "MSG: #{post["message"]};\n" +
			  "SHARES: #{post["shares"]};\n" +
			  "LIKES: #{post["likes"]};\n" +
			  "PROPERTIES: #{post["properties"]};\n" +
			  "CREATED: #{post["created_time"]}"
		f.puts "ID: #{post["id"]};\n" +
		      "MSG: #{post["message"]};\n" +
			  "SHARES: #{post["shares"]};\n" +
			  "LIKES: #{post["likes"]};\n" +
			  "PROPERTIES: #{post["properties"]};\n" +
			  "CREATED: #{post["created_time"]}" 
	end
	created_time = DateTime.parse(y_response.last["created_time"])
	puts "CreatedTime: #{created_time.to_s}"
	f.puts "CreatedTime: #{created_time.to_s}"

	y_response = y_response.next_page
end	

f.close

puts "Count: #{counter}"