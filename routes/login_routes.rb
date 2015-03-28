require 'sinatra/base'
require_relative './../helpers/auth'

class LoginRoutes < Sinatra::Base
	enable :sessions
	register Sinatra::SessionAuth
	set :views, File.expand_path('./../../views', __FILE__)
	set :public_folder, File.expand_path('./../../public', __FILE__)

	get '/' do
		connection = ActiveRecord::Base.connection

		if authorized?
			@tweets = connection.exec_query %Q(
				SELECT followees.id, followees.name, followees.username, tweets.text, tweets.created_at
				FROM users
				JOIN followerships ON followerships.user_id = users.id
				JOIN users AS followees ON followees.id = followerships.followee_id
				JOIN tweets ON tweets.user_id = followees.id
				WHERE users.id = #{@current_user.id} 
				ORDER BY tweets.created_at DESC
				LIMIT 100)

		else
			@tweets = connection.exec_query %Q(
				SELECT users.id, users.name, users.username, tweets.text, tweets.created_at
				FROM tweets
				JOIN users ON tweets.user_id = users.id
				ORDER BY tweets.created_at DESC
				LIMIT 100)
		end		

			@tweets = @tweets.rows
			erb :index
	end

	get '/login' do
		erb :login
	end

	get '/register' do
		erb :register
	end

	# verify a user name and password 
	post '/login' do
		begin
			user = User.find_by(:username => params["username"],
								:password => params["password"]) 
			if user
				login! user
				redirect '/'
			else
				error 400, {:error => "invalid login credentials"}.to_json
			end
		rescue => e
			error 400, e.message.to_json
		end 
	end

	put '/logout' do
		logout!
		redirect to '/login'
	end

end
