require 'koala'
require 'json'
require 'fileutils'
require 'date'
require_relative 'post'

oauth_access_token = "EAACEdEose0cBALUcRcp5Uk1LLsxgvCDynnfJKZAN3PI5QSxDqWM86BNUbqAQ7dWsBfF9bqiKsmBBZABaCUpFyrFuZCpe3Xn5JR8uO7NOTzetvYmV693tILzsqxT66QDO3CiGOX3JVUTNEKLLx9pR5c28JYzcOVXmURJbA56c42QLKN4RNyPBL8y0OX1cntAdbssxRaZBejojJgw3SkYh"
@graph = Koala::Facebook::API.new(oauth_access_token)

outfile = "\\dev\\rubywork\\koala\\output\\count_country_ymr_jp_1.out"
outdir = File.dirname(outfile)

unless File.directory? outdir
  FileUtils.makedirs outdir
end

f = File.new(outfile, "w")
cuttoff = DateTime.new(2017,3,14)
created_time = DateTime.new(2017,3,28)
counter = 0						

y_response = @graph.get_connection('YANMAR.Official','insights/page_fans_country/lifetime?&since=2017-3-07&until=2017-3-28')
posts = []

puts y_response.class
@daily = []
y_response[0]["values"].each do |v|
  puts v["end_time"]
  f.puts v["end_time"]
  @total = 0
  v["value"].each do |c, m|
    puts "Country: #{c}: #{m}"
	f.puts "#{c}#{m}"
	@total += m
  end
  @daily << @total
end
puts "Last: #{@daily.last}"
puts "Change: #{@daily.last - @daily.first}"
f.puts "Last: #{@daily.last}"
f.puts "Change: #{@daily.last - @daily.first}"