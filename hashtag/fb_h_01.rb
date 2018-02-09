require 'koala'
require 'json'
#require 'csv'
#require 'fileutils'
#require 'date'
#require_relative 'post'

oauth_access_token = "EAACEdEose0cBAMAzzzy7MyDGTZAiuW191g7ZAXSWgMJM1RZBIDEIEkEOi1xmJ92ndPpbECP01OG5OicmyshZAZBwgiYimrlaDjPoZBtgqZCK4VEZB3ZC709jSbZAOFG8IoS4ulQZBffop7sdZAA3UTGulXPzb4zKk5tqt5wOYMTpO8b64ZAt0mk5Gj9VwBVPxsi21BLJZCUon6b9evcwZDZD"
@graph = Koala::Facebook::API.new(oauth_access_token)

#outfile = "\\dev\\rubywork\\koala\\output\\hashtag_01.out"
#outdir = File.dirname(outfile)

#unless File.directory? outdir
#  FileUtils.makedirs outdir
#end

#f = File.new(outfile, "w")

y_response = @graph.search('otusa', type: :place)

	y_response.each do |post|
	    puts post
	end
	

#	y_response = y_response.next_page

#f.close

#puts y_response.class.name