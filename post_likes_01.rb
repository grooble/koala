require 'koala'
require 'json'
require 'fileutils'
require 'date'
require_relative 'post'

oauth_access_token = "EAACEdEose0cBADRBZAZAg8hk4roCOpjWB2ydYUfXm7JwgqNu0bpMUzR3DcZC7EdzMoZB7uE1bVFaVqquvTCe33p0BR169dm5Rorx9RYcUe9M0e5p3EWymspPc6yd2XbpOgoeIN1d95IzGkoBtbi8khJROQqMiCI4umKZBnqzQFsZBjZCd0ZAwhBW5xc5lhfDPeq9IKlx0RDMNK8vxwFINy1e"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\post_likes_01.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")

y_response = @graph.get_object("1851159494903766/likes?summary=1").raw_response["summary"]["total_count"]
posts = []

puts y_response
