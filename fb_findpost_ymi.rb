require 'koala'
require 'json'
require 'csv'
require 'fileutils'
require 'date'
require_relative 'post'

oauth_access_token = "EAACEdEose0cBAFlqYOZAbnIOg9BN46M09H6xZAuFbVt5VVzwyODuXJMT1RIcMJ4sz9BWXPCxzgTneLdqX84gOfbHVojB8SI19eUa8ZBXjmRoqGNpw1vFlfrTqRAKeueDLMLX2hUqaiqCIT5nQEgGT7y6k0lyNVhlEZBKgRYZAdJZBfRs8H42qpccuZCJI6FNMEYiZAHBZBVa7hwZDZD"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\ymi_1a.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
cuttoff = DateTime.new(2017,04,17)
created_time = DateTime.new(2017,04,18)
counter = 0						

y_response = @graph.get_connection('yanmarmarineinternational','posts',
								{fields: ['message', 'id', 'from', 'type', 'properties', 'link', 'shares', 'likes', 'comments', 'created_time', 'updated_time']
								})
posts = []

f.puts "ID;" +
	  "MSG;" +
	  "SHARES;" +
	  "LIKES;" +
	  "COMMENTS;" +
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
			 :comments => post["comments"],
			 :created_time => post["created_time"],
			 :updated_time => post["updated_time"]})
			 
		
		puts "ID: #{post["id"]};\n" +
              "MSG: #{post["message"] if !post["message"].nil?};\n" +
			  "SHARES: #{post["shares"]};\n" +
			  "LIKES: #{post["likes"]};\n" +
			  "COMMENTS: #{post["comments"]};\n" +
			  "PROPERTIES: #{post["properties"]};\n" +
			  "CREATED: #{post["created_time"]}"
		puts
		post_ary = [post["id"], post["message"], post["shares"], post["likes"], post["comments"], post["properties"], post["created_time"]]
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