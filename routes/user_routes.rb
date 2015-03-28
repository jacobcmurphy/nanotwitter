require 'active_record'
require 'sinatra/base' 
require_relative './../helpers/auth'
require_relative './../models/user'
require_relative './../models/tweet'


class UserRoutes < Sinatra::Base
	enable :sessions
	register Sinatra::SessionAuth
	set :views, File.expand_path('../../views', __FILE__)

	get '/my/profile' do
		authorize!
		if @current_user 
			@followees = @current_user.followees
			erb :profile
		else
			redirect '/login'
		end
	end

	get '/:id' do
		@user = User.find(params[:id]) 
		if @user 
			@is_your_page = @user == get_current_user
			@tweets = Tweet.joins(:user).select('users.name', 'users.username', 'users.id', 'tweets.user_id', 'tweets.text', 'tweets.created_at').where('tweets.user_id = ?', @user.id).order('tweets.created_at DESC').limit(100)
			erb :user
		else
			error 404
		end
	end

	# create a new user
	post '/' do
		begin
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
