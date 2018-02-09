require 'koala'
require 'json'
require 'csv'
require 'fileutils'
require 'date'
require_relative 'post'

oauth_access_token = "EAACEdEose0cBAPlLi03FHEfwFpt6OkXX5mjCUsD4ZB31y3pUupH4ChI451RqqNMsm8zyIZAP5hhtlTfgOlaZAyXRGGyCTe7sinqs418t5GZBPmpfoHUZB86YHmM47HD3YpfZAnc2qB6k8cQKPOM3l8H2Pupkgofs7mejICZCnlEqxUUvd2WdQanZCzszwZCGj6NOZBJxgUqDYVLQZDZD"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\toyota_JP.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
cuttoff = DateTime.new(2017,03,01)
created_time = DateTime.new(2017,04,18)
counter = 0						

y_response = @graph.get_connection('ToyotaMotorCorporation','posts',
								{fields: ['message', 'id', 'from', 'type', 'properties', 'link', 'shares', 'likes.summary(true)', 'comments.summary(true)', 'created_time', 'updated_time']
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
	    message = post["message"]
		unless message.nil?
		  message = "hello"
		end
		y_post = Post.new({:message => message,
			 :id => post["id"],
			 :from => post["from"],
			 :type => post["type"],
			 :properties => post["properties"],
			 :link => post["link"],
			 :shares => post["shares"],
			 :likes => post["likes"]["summary"]["total_count"],
			 :comments => post["comments"]["summary"]["total_count"],
			 :created_time => post["created_time"],
			 :updated_time => post["updated_time"]})
			 
		
		puts "ID: #{post["id"]};\n" +
              "MSG: #{post["message"] if !post["message"].nil?};\n" +
			  "SHARES: #{post["shares"]};\n" +
			  "LIKES: #{post["likes"]};\n" +
			  #"LIKES: #{post["likes"]["summary"]["total_count"]};\n" +
			  "COMMENTS: #{post["comments"]};\n" +
			  "PROPERTIES: #{post["properties"]};\n" +
			  "CREATED: #{post["created_time"]}"
		puts
		puts post["shares"]
		
		#post_ary = [y_post["id"], y_post["message"], y_post["shares"], y_post["likes"], y_post["comments"], y_post["properties"], y_post["created_time"]]
		post_ary = [y_post.id, y_post.message, y_post.shares, y_post.likes, y_post.comments, y_post.properties, y_post.created_time]
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

puts y_response.class.name

puts "Count: #{counter}"
puts "POSTS: #{posts.size}"