require 'sinatra/base'
require 'sinatra/activerecord'
require_relative "../models/tweet"

class ApiTweetRoutes < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	get '/tweets/:id' do
		pass if params[:id] == 'recent'
		tweet = Tweet.find(params[:id])
		if tweet
			status 200
			tweet.to_json
		else
			status 404
			{"Message" =>  "No tweet found with that id."}.to_json
		end
	end

	get '/tweets/recent' do
		date = (params[:date]) ? DateTime.parse(params[:date]) : Time.now.to_datetime
		Tweet.where(['created_at < ?', date]).order(created_at: :desc).limit(100).to_json
	end
end
