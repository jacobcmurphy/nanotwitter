require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/cross_origin'
require_relative "../models/hashtag"

class HashtagRoutes < Sinatra::Base
  configure do
    enable :cross_origin
  end

  options "*" do
    response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Methods"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
    
    # Needed for AngularJS
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    200
  end

	register Sinatra::ActiveRecordExtension
	register Sinatra::CrossOrigin

	# get all ids with tag
	get '/:tag' do
		results = {}
		results[:tag] = params[:tag]
		results[:tweet_ids] = Hashtag.where(tag: params[:tag]).select("tweet_id").map{|tweet| tweet.tweet_id}
		if results[:tweet_ids].empty?
				status 404
				{"error": "user not found"}.to_json
		else
			status 200
			results.to_json
		end
	end

	# insert a new tag
	post '/:tag' do
		hashtag = Hashtag.create(tag: params["tag"], tweet_id: params[:tweet_id]) if params[:tweet_id]
		if hashtag.valid?
			status 201
			hashtag.to_json
		else
			status 500
			hashtag.errors.to_json
		end
	end
			
end
