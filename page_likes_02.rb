require 'koala'
require 'json'
require 'fileutils'
require 'date'
require_relative 'post'

oauth_access_token = "EAACEdEose0cBAIgEPzsY7pLTLww37lR2YqYQWW27vPyoEMTizp35r4tNMhYIBebOwEsNJwh3HUZCKaiqTF8LUcYvL1ayRz8UEV2zhSDfCtUROCJpC5sPK4gws81XeugokrPCGoRCNltzBiypcCvHlTBtZABLcjJbw9aGBZBRj6Lyuq4ulVb7aRN308CiMZCoVS8Q5D45ke76SM2ZCNuxI"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\USERS\\AA502323\\Documents\\ruby\\koala\\output\\page_likes_02.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
y_response = @graph.get_object("431753333699609/page_fans")
while not y_response.empty? do
  y_response.each do |r|
    f.puts r["name"]
  end
  y_next = y_response.next_page
  y_response = y_next
end