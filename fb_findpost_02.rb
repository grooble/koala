require 'koala'
require 'json'
require 'fileutils'
require 'date'

oauth_access_token = "EAACEdEose0cBANvqNtjxISjpXxoApT08cDkZCNBVZBALzf5kjiXdQm3TXwZAE1uSCcMLBfZBcPPyeAVcmCvItvFrc2NPSykLx1tF2ZCh3P0fw38mRbw3ZCiEnefCBYFmo2DdN5GZApfhaucTF3H4uTC9P3ZBtpCQdGiRzZAswAhhq7It6gDM64yl2"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\records_4.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
@cuttoff = DateTime.new(2016,10,1)
@created_time = DateTime.new(2016,12,10)
counter = 0						

#for i in 0..2 do
    y_response = @graph.get_connection('YANMAR.Global.Official','posts',
									{fields: ['message', 'id', 'from', 'type', 'properties', 'link', 'shares', 'created_time', 'updated_time']
									})
# puts y_response.length
	created_time = DateTime.parse(y_response.last["created_time"])
	
	y_response.each do |post|
		counter += 1
		puts "ID: #{post["id"]};\n MSG: #{post["message"]};\n SHARES: #{post["shares"]};\n PROPERTIES: #{post["properties"]};\n CREATED: #{post["created_time"]}"
		f.puts "ID: #{post["id"]};\n MSG: #{post["message"]};\n SHARES: #{post["shares"]};\n PROPERTIES: #{post["properties"]};\n CREATED: #{post["created_time"]}" 
	end

#	puts "NEXT_PAGE_PARAMS: #{y_response.next_page_params}"
#f.puts "POST COUNT: #{counter}"
#puts "POST COUNT: #{counter}"
	y_response_next = y_response.next_page

	y_response_next.each do |post|
		counter += 1
		puts "ID_N: #{post["id"]};\n MSG_N: #{post["message"]};\n SHARES_N: #{post["shares"]};\n PROPERTIES_N: #{post["properties"]};\n CREATED_N: #{post["created_time"]}"
		f.puts "ID_N: #{post["id"]};\n MSG_N: #{post["message"]};\n SHARES_N: #{post["shares"]};\n PROPERTIES_N: #{post["properties"]};\n CREATED_N: #{post["created_time"]}" 
	end
	

f.close

# puts "FIRST: #{y_response.first}"
puts "FIRST CREATED: #{y_response.first["created_time"]}"

d = DateTime.parse(y_response.first["created_time"])
puts "DateTime: #{d.to_s}"
d_test = DateTime.new(2016, 6,1)
puts "#{d.to_s} is after #{d_test.to_s}? #{d > d_test}"