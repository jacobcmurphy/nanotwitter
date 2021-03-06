require 'sinatra'
require 'json'
require 'redis'
require_relative '../helpers/redis_helper'
require_relative '../helpers/db_helper'

class BaseRoutes < Sinatra::Base
	set :public_folder, 'public'
	include RedisConnect
	include Database
	
	get '/' do
		#return @@main
		@main ||= File.read(File.join('public', 'index.html'))
		@main
	end

	# for the instructor testing
	get '/test_tweet' do
		test_user_email = "test@example.com"
		test_user_password = "testtest"
		text = "I only exist for your testing - #{Time.now}"
		DB['INSERT INTO tweets(text, user_id) VALUES(?, (SELECT id FROM users where email=? AND password=?))', text, test_user_email, test_user_password].insert
		status 200
		"Confirmed #{Time.now}"
	end

	# mimicks a post to /api/v1/follow for the Test user
	get '/test_follow' do
		follow_id = rand(1...1000)
		test_user_email = "test@example.com"
		test_user_password = "testtest"
		begin
			DB['INSERT INTO following(follower, followee) VALUES((SELECT id FROM users where email=? AND password=?), ?)', test_user_email, test_user_password, follow_id].insert
		rescue
		end
		status 200
		"Confirmed #{Time.now}"
	end

	# would actually be a delete request
	get '/reset' do
		test_user_email = "test@example.com"
		test_user_password = "testtest"
		DB['DELETE FROM following WHERE follower = (SELECT id FROM users where email=? AND password=?)', test_user_email, test_user_password].delete
		DB['DELETE FROM tweets WHERE user_id = (SELECT id FROM users where email=? AND password=?)', test_user_email, test_user_password].delete
		status 200
		"Confirmed #{Time.now}"
	end

	# loader.io validation endpoints
	get 'loaderio-3a56c6f3181bf46c14582978f30c3c83' do
		status 200
	end

	get 'loaderio-feafc7f9426987c407a62f6375f1c865' do
		status 200
	end

	get 'loaderio-211ffded21975d2a7404c4d83638692b' do
		status 200
	end

end
