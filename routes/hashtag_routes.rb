require 'sinatra/base'
require 'sinatra/activerecord'
require_relative "../models/hashtag"

class HashtagRoutes < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	# get all ids with tag
	get '/:tag' do
		ids = Hashtag.where(tag: params[:tag]).select("tweet_id")
		status 200
		ids.as_json.to_json
	end

	# insert a new tag
	put '/:tag' do
		hashtag = Hashtag.create(tag: params[:tag], tweet_id: params[:tweet_id]) if params[:tweet_id]
		status 201
		hashtag.to_json
	end
			
end
