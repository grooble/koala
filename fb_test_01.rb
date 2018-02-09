require 'koala'
require 'json'
require 'fileutils'

oauth_access_token = "CAACEdEose0cBANBX1CHwEv3ZAjf9yjnohOSEDI8T8LYV4AiEyvFFeUsUH3oIPrVD23h4eLJgo2wn6V8gWDkl6U2hZAs381YESZClgFluGEClUNV9LEKY9OnRUYLQzurRm0EV2i92FnAkOidIszNz41ZAYTjQ2aNKtcZC1s5hIwMComkn0kVeetiIFKNqhUpaZBTL8WkeuhKAZDZD"
@graph = Koala::Facebook::API.new(oauth_access_token)

y_response = @graph.get_object("search?q=yanmar&type=page")

y_response.delete_if { |n| n["name"].downcase.include?("myanmar") }
          .each_with_index { |a, i| puts "#{i}:: Id: #{a["id"]}; Name: #{a["name"]}." }

first_co = y_response.first  
puts "first: #{first_co}."
f_posts = @graph.get_connection(431753333699609, 'posts', 
					{
					  limit: '2',
                      fields: ['message', 'id', 'from', 'type',
                                'picture', 'link', 'created_time', 'updated_time'
							]
					})
puts "Top post date: #{f_posts.first["created_time"]}\nmessage:\n#{f_posts.first["message"]}."

#response.each_with_index {|a, i| puts "#{i}. Name: #{a["name"]}." }

outfile = "\\dev\\rubywork\\koala\\output\\records.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
f.puts y_response.to_s
f.puts "first: #{first_co}."
f.close