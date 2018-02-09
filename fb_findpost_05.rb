require 'koala'
require 'json'
require 'csv'
require 'fileutils'
require 'date'
require_relative 'post'

oauth_access_token = "EAACEdEose0cBABrMesdnHDkSI67ZA7cC98ZBNAScW55X3u6BDGabRFZALPsEAWZBiI2Y3ROA3ZC3ZCvDZCZAlAVUUo0XZAfsQIONlsGQo8N4qWt8XCisfHNiDzuouz7iDLsdGq6o3XspPkufivh2RMFIQNcwFXtpSXSs7rRWtIzwa2XEKzNHKjJHh"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\records_4_2.out"
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
posts = []

f.puts "ID;" +
	  "MSG;" +
	  "SHARES;" +
	  "LIKES;" +
	  "PROPERTIES;" +
	  "CREATED" 

while created_time > cuttoff do
	y_response.each do |post|
		y_post = Post.new({:message => post["message"],
			 :id => post["id"],
			 :from => post["from"],
			 :type => post["type"],
			 :properties => post["properties"],
			 :link => post["link"],
			 :shares => post["shares"],
			 :likes => post["likes"],
			 :created_time => post["created_time"],
			 :updated_time => post["updated_time"]})
			 
		
		puts "ID: #{post["id"]};\n" +
              "MSG: #{post["message"].delete("\n") if !post["message"].nil?};\n" +
			  "SHARES: #{post["shares"]};\n" +
			  "LIKES: #{post["likes"]};\n" +
			  "PROPERTIES: #{post["properties"]};\n" +
			  "CREATED: #{post["created_time"]}"
		puts
		post_ary = [post["id"], post["message"].delete("\n") if !post["message"].nil?, post["shares"], post["likes"], post["properties"], post["created_time"]]
		f.puts post_ary.to_csv(:col_sep => ";")
	    
		counter += 1
		posts << y_post
	end
	
	created_time = DateTime.parse(y_response.last["created_time"])
	puts "CreatedTime: #{created_time.to_s}"
#	f.puts "CreatedTime: #{created_time.to_s}"

	y_response = y_response.next_page
end	

f.close

puts "Count: #{counter}"
puts "POSTS: #{posts.size}"