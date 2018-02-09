require 'koala'
require 'json'
require 'fileutils'
require 'date'
require_relative 'post'

oauth_access_token = "EAACEdEose0cBAOfzpj0kvxlEC6wrJJjL8hBvsBqW5CA3OcwlChcmcZBLl60Kp3rdfCRcmX6cX2iZCIE9ADTtZCJeH5J6iODqTic03gD9EqrHx80UPZA05hULgMwKahZC3JfizbdZAOxHMQgeHjq7wEnykW7GJXFX8DiWpam2R91ZB25fpJcP0NNCeH6uMbrmPoMi6rMnhgGNQZDZD"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\records_k_13.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
cuttoff = DateTime.new(2016,12,25)
created_time = DateTime.new(2017,1,24)
counter = 0						

y_response = @graph.get_connection('kubotatractor','posts',
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
			 :shares => post["shares"].count,
			 :likes => post["likes"],
			 :created_time => post["created_time"],
			 :updated_time => post["updated_time"]})
			 
		
		puts "ID: #{post["id"]};\n" + 
              "MSG: #{post["message"]};\n" +
			  "SHARES: #{post["shares"]};\n" +
			  "LIKES: #{post["likes"]};\n" +
			  "PROPERTIES: #{post["properties"]};\n" +
			  "CREATED: #{post["created_time"]}"
		puts
		
		f.puts "#{post["id"]};" +
		      "#{post["message"]};" +
			  "#{post["shares"]};" +
			  "#{post["likes"]};" +
			  "#{post["properties"]};" +
			  "#{post["created_time"]}" 
	    
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