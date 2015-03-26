require 'sinatra/base'
require_relative './../helpers/auth'

class LoginRoutes < Sinatra::Base
	register Sinatra::SessionAuth
	set :views, File.expand_path('./../../views', __FILE__)

	get '/' do
		if @current_user
			@tweets = @current_user.followees.tweets.order('created_at DESC').limit(50)
		else
			@tweets = Tweet.order('created_at DESC').limit(50)
		end		
		erb :index
	end

	get '/login' do
		erb :login
	end

	get '/register' do
puts "HELLO?"
		erb :register
	end

	# verify a user name and password 
	post '/login' do
		begin
			attributes = 
			user = User.find_by(:username => params["username"],
								:password => params["password"]) 
			if user
				session[:username] = user.username
				session[:token] = user.password
				redirect '/'
			else
				error 400, {:error => "invalid login credentials"}.to_json
			end
		rescue => e
			error 400, e.message.to_json
		end 
	end

	put '/logout' do
		session[:user_id] = nil
		session[:token] = nil
		redirect to '/login'
	end

end
