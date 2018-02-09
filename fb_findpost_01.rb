require 'koala'
require 'json'
require 'fileutils'

oauth_access_token = "EAACEdEose0cBACg1weLXzIAQZAMZB6GSei2vBU9XiZB4MFJHIZC2uZATftEIqU4IutFDKlhKGE43wQxWNLBvsxPZBY40xlYOPQ9nMd5FNRypxjXvlqsYFRhvty0YhZART0G01BWceHQLpFZAM8QR6izZCeom0ZASd2zj3cfitEZAmSjnOKYJTaE36CqysZCqbNHZBedtEE1KDzLU6ywZDZD"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\records_k_1.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")

y_response = @graph.get_connection('kubotatractor','posts',
									{fields: ['message', 'id', 'from', 'type', 'properties', 'link', 'shares', 'created_time', 'updated_time']
									})
puts y_response.length

counter = 0						
y_response.each do |post|
    counter += 1
    puts "ID: #{post["id"]};\n MSG: #{post["message"]};\n SHARES: #{post["shares"]};\n PROPERTIES: #{post["properties"]};\n CREATED: #{post["created_time"]}"
	f.puts "ID: #{post["id"]};\n MSG: #{post["message"]};\n SHARES: #{post["shares"]};\n PROPERTIES: #{post["properties"]};\n CREATED: #{post["created_time"]}" 
end

f.puts "POST COUNT: #{counter}"
puts "POST COUNT: #{counter}"
f.close