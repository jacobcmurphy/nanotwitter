require 'sinatra'
require 'json'
require 'sequel'

class BaseRoutes < Sinatra::Base
	set :public_folder, 'public'
	DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'postgres', :user => 'edenzik')


	# loader.io validation endpoint
	get 'loaderio-3a56c6f3181bf46c14582978f30c3c83' do
		status 200
	end

	get '/' do
		redirect '/index.html'
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
