require 'koala'
require 'json'
require 'fileutils'
require 'date'
require_relative 'post'

oauth_access_token = "EAACEdEose0cBAPxkw6FYPar1qJa8KujarXvJcHT3wDwKwFbhz0H2d96VscZALzppg7tEZB24ph2XhsGi4OZBWrnZCmlU57bLw6v3V7FMHESrllu9u4Ag3ynmwXSmYJZBWIWDJ0L7CXhhAEEUDTGa8ZCQiyWg8xRFlpADIJj2tF10HHZAWmVLo1zAt9wWEP6OjQnIwtAvuvn1QZDZD"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\kubota_count_country_01.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
cuttoff = DateTime.new(2016,11,30)
created_time = DateTime.new(2016,12,31)
counter = 0						

y_response = @graph.get_connection('YANMAR.Official','posts',
								{fields: ['id', 'message', 'likes', 'comments', 'sharedposts', 'created_time']
								})
posts = []

f.puts "ID;" +
      "LIKES;" +
	  "COMMENTS" +
	  "SHARED" +
	  "CREATED" 

while created_time > cuttoff do
	y_response.each do |post|
		y_post = Post.new({
			 :id => post["id"],
			 #:likes => post["likes"]["data"].count,
			 :likes => nil,
			 :comments => nil,
			 :shares => nil,
			 :created_time => post["created_time"]
			 })
			 
        @all_comments = @graph.get_connections(y_post.id, 'comments', limit: 100, filter: 'stream')
		@comments_list = []
		begin
		  @all_comments.each do |c|
            @comments_list << c
          end
       	  @all_comments = @all_comments.next_page
        end while @all_comments != nil		  
		y_post.comments = @comments_list.count

        @all_likes = @graph.get_connections(y_post.id, 'likes', limit: 100, filter: 'stream')
		@like_list = []
		begin
		  @all_likes.each do |l|
            @like_list << l
          end
       	  @all_likes = @all_likes.next_page
        end while @all_likes != nil		  
		y_post.likes = @like_list.count

        @all_shares = @graph.get_connections(y_post.id, 'sharedposts', limit: 100, filter: 'stream')
		@share_list = []
		begin
		  @all_shares.each do |s|
            @share_list << s
          end
       	  @all_shares = @all_shares.next_page
        end while @all_shares != nil		  
		y_post.shares = @share_list.count
		
		
		puts "ID: #{post["id"]};\n" + 
		     #"LIKES: #{post["likes"]["data"].count};\n" + 
			 "LIKES: #{y_post.likes};\n" + 
			 #"COMMENTS: #{post["comments"]};\n" +
			 "COMMENTS: #{y_post.comments};\n" +
			 #"SHARED:  #{post["sharedposts"]};\n" +
			 "SHARED:  #{y_post.shares};\n" +
			 "CREATED: #{post["created_time"]}"
		puts
		
		f.puts "#{post["id"]};" +
		       #"#{post["likes"]["data"].count};" +
		       "#{y_post.likes};" +
			   #"#{post["comments"]};" +
			   "#{y_post.comments};" +
			   #"#{post["sharedposts"]};" +
			   "#{y_post.shares};" +
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