require 'sinatra/base'
require 'sinatra/activerecord'
require_relative '../models/user'
require_relative "../models/tweet"

class ApiRoutes < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	get '/tweets/:id' do
		tweet = Tweet.find(params[:id])
		if tweet
			status 200
			tweet.to_json
		else
			status 404
			{"Message": "No tweet found with that id."}.to_json
		end
	end

	get '/tweets/recent' do
		Tweets.order(created_at: :asc).to_json
	end

	get '/users/:id' do
		begin
			user = User.find(params[:id])
			if user
				status 200
				user.to_json(only: [:id, :name, :username])
			else
				status 404
				{"Message": "No user exists with that id."}.to_json
			end
		rescue => e
			status 500
			e.errors.to_json
		end
	end

	get '/users/:id/tweets' do
		begin
			user = User.find(params[:id])
			if user
				status 200
				user.tweets.to_json
			else
				status 404
				{"Message": "No user exists with that id."}.to_json
			end
		rescue
			status 500
			e.errors.to_json
		end
	end
end
