require 'sinatra/base'
require 'sinatra/activerecord'
require_relative './../helpers/auth'
require_relative "../models/tweet"

class TweetRoutes < Sinatra::Base


	register Sinatra::SessionAuth
	register Sinatra::ActiveRecordExtension

	post '/' do
		authorize!
		begin
			Tweet.create(text: params[:text], user_id: @current_user.id)
			status 200
			redirect back
		rescue => e
			status 400	#malformed
			e.errors.to_json
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
