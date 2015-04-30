require 'sinatra'
require 'json'
require 'sequel'
require 'redis'

class BaseRoutes < Sinatra::Base
	set :public_folder, 'public'
	r = Redis.new

	# loader.io validation endpoint
	get 'loaderio-3a56c6f3181bf46c14582978f30c3c83' do
		status 200
	end

	get 'loaderio-feafc7f9426987c407a62f6375f1c865' do
		status 200
	end

	# loader.io validation endpoint
	get 'loaderio-211ffded21975d2a7404c4d83638692b' do
		status 200
	end

	get '/' do
		if r.get(:main).nil?
			result =  File.read(File.join('public', 'index.html'))
			r.set(:main,result)
			return result
		end
		return r.get(:main)
		#redirect '/index.html'
	end

	# for the instructor testing
	get '/test_tweet' do
		test_user_email = "test@example.com"
		test_user_password = "testtest"
		text = "I only exist for your testing - #{Time.now}"
		DB['INSERT INTO tweets(text, user_id) VALUES(?, (SELECT id FROM users where email=? AND password=?))', text, test_user_email, test_user_password].insert

	end

	# mimicks a post to /api/v1/follow for the Test user
	get '/test_follow' do
		follow_id = rand(1...1000)
		test_user_email = "test@example.com"
		test_user_password = "testtest"
		DB['INSERT INTO following(follower, followee) VALUES((SELECT id FROM users where email=? AND password=?), ?)', test_user_email, test_user_password, follow_id]
	end

	# would actually be a delete request
	get '/reset' do
		test_user_email = "test@example.com"
		test_user_password = "testtest"
		DB['DELETE FROM following WHERE follower = (SELECT id FROM users where email=? AND password=?)', test_user_email, test_user_password].delete
		DB['DELETE FROM tweets WHERE user_id = (SELECT id FROM users where email=? AND password=?)', test_user_email, test_user_password].delete
	end

end
