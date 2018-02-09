require 'koala'
require 'json'
require 'fileutils'
require 'date'
require_relative 'post'

oauth_access_token = "EAACEdEose0cBAIRLdGd3GYXtO9R7HQQPaLdH5lgABdEtn0xHXpJLmZAOGkKFAUTWvDFr2wiDP57yNUwMZBkhRLTQLtXLZA3JslkAZBiehCpczxFtMwWjbb6G8osm6ZBbZAMWOZAs0HjNwGYd99OlPqtXZAro8TaRDBEssZAkaDJw4csKiOrfYO03FGEYL2cqQWZCy8dsByzgPrNL3oQo9Y3mVB"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\post_likes_01.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
y_response = @graph.get_object("1851159494903766/likes?summary=1")
while not y_response.empty? do
  f.puts y_response.name
  y_next = y_response.next_page
  y_response = y_next
end
# f.puts y_response
#y_2 = y_response.next_page

#f.puts y_response
#f.puts "----"
#f.puts y_2