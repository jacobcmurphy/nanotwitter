require 'sinatra/base'
require 'sinatra/activerecord'
require_relative "../models/tweet"

class TweetRoutes < Sinatra::Base
	enable :sessions
	register Sinatra::SessionAuth
	register Sinatra::ActiveRecordExtension

	post '/' do					#if post at /tweet
		autorize!
		tweet = JSON.parse request.body.read		#receives tweet
		begin
			Tweet.create(tweet)
			200					#good response
		rescue => e
			puts e
			400					#malformed
		end
	end

	# gets all tweets
	get '/all' do
		tweets = Tweet.order('created_at DESC').limit(50)
	end

	get '/for/:user_id' do
		begin
			tweets = Tweet.where(user_id: params[:user_id])
			200
			tweets.to_json
		rescue
			400 	#malformed
		end
	end

end
