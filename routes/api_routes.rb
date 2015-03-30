require 'sinatra/base'
require 'sinatra/activerecord'
require_relative '../models/user'
require_relative "../models/tweet"

class ApiRoutes < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	get '/tweets/:id' do
		pass if params[:id] == 'recent'
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
		date = (params[:date]) ? DateTime.parse(params[:date]) : Time.now.to_datetime
		Tweet.where(['created_at < ?', date]).order(created_at: :desc).limit(50).to_json
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
			e.to_json
		end
	end

	get '/users/:id/tweets' do
		begin
			date = (params[:date]) ? DateTime.parse(params[:date]) : Time.now.to_datetime
			tweets = Tweet.where(['user_id = ? and created_at < ?', params[:id].to_i, date]).order(created_at: :desc).limit(50)
			if tweets.size > 0
				status 200
				tweets.to_json
			else
				status 404
				{"Message": "No user exists with that id."}.to_json
			end
		rescue => e
			status 500
			e.to_json
		end
	end
end
