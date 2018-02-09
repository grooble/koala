require 'koala'
require 'json'
require 'fileutils'

oauth_access_token = "CAACEdEose0cBAGpyIQZAW4AnKNub3OGFvMumFbwYUyAvFa5PztrnKFidZCyvBzzUvQHIiy1x4fQrMsR372E0RWWrZAa06b0Upyztl1cEbgD8U6raYB66tEjRgInq8KNDKZBXOEyG07b3wpoxYo05noHs8D9SwQMq4G0idjzBA9HZA4RJ9ZBZAvZCLuqq1P218Q7yQ6cwNfJhq3TWX694XYtX25XS3Kn3vdgZD"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\records2.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")

y_response = @graph.get_object("search?q=yanmar&type=page")

y_response.delete_if { |n|  n["name"].downcase.include?("myanmar") }
           .each_with_index do |a, i|
		     index = a["id"]
             f_posts = @graph.get_connection(index, 'posts', 
			   {
				#limit: '2',
                fields: [
				        'message',
						'id',
#						'from',
#						'type',
#                       'picture',
#						'link',
						'created_time',
#						'updated_time'
						]
				})
			 unless (f_posts.length == 0)
			   puts "#{i}:: Id: #{a["id"]}; Name: #{a["name"]}.; posts: #{f_posts.length}; recent: #{f_posts.first["created_time"]}" 
			   f.puts "#{i}:: Id: #{a["id"]}; Name: #{a["name"]}.; posts: #{f_posts.length}; recent: #{f_posts.first["created_time"]}"
			 end
		   end
f.close


