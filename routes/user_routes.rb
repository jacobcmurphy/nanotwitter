require 'active_record'
require 'sinatra/base' 
require_relative './../helpers/auth'
require_relative './../models/user'


class UserRoutes < Sinatra::Base

	register Sinatra::SessionAuth
	set :views, File.expand_path('../../views', __FILE__)

	get '/my/profile' do
		if @current_user 
			@followees = @current_user.followees
			erb :profile
		else
			redirect '/login'
		end
	end

	get '/:username' do
		@user = User.find(username: params[:username]) 
		if @user 
			@your_page = @user.eq @current_user
			@tweets = @user.tweets.order('created_at DESC').limit(50)
			erb :user
		else
			error 404
		end
	end

	# create a new user
	post '/' do
		begin
puts params.inspect, "*******"
			user = User.create(name: params[:name],
							   username: params[:username],
							   email: params[:email],
							   password: params[:password])
			if user.valid?
				redirect '/login'
			else
				error 400, user.errors.to_json
			end
		rescue => e
			error 400, e.message.to_json
		end
	end

end
