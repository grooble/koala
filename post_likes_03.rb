require 'koala'
require 'json'
require 'fileutils'
require 'date'
require_relative 'post'

oauth_access_token = "EAACEdEose0cBAGxq9yRfLlsuE0nb6MBPwkTNCZAvwob3zmyq2WLC31kOGr0qhJtJPaRqV82AECyr7fN6X0d19M8ABZAJPFdJRj1Wb0mOzQM0Qknd24jKzoACn2Ud0ytIPS0ZALLqZC5VvxvjtXUZBrjaGpnPtkI2TrjRv9obGp2esqPQf7ub7By54gOIecHNwZBigIk1dZCg5z3WlZAfxpdw"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\USERS\\AA502323\\Documents\\ruby\\koala\\output\\post_likes_T.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
y_response = @graph.get_object(1851159494903766, :fields => "likes.summary(1)")
puts "response: #{y_response.size}"
while not y_response.empty? do
  y_response.each do |r|
    puts "class: #{r.class}"
	puts "first: #{r.first}"
	puts "r size: #{r.size}"
	puts " first class: #{r.first.class}"
    f.puts r.to_s
  end
  y_next = y_response.next_page
  y_response = y_next
end