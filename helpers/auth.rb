require 'sinatra/base'
require_relative './../models/user'

module Sinatra
	module SessionAuth
		module Helpers
			def authorized?
				@current_user = User.find_by(username: session[:username], password: session[:token])
				return @current_user
			end

			def authorize!
				redirect '/login' unless authorized?
			end

			def login!(user)
				session[:username] = user.username
				session[:token] = user.password
			end

			def logout!
				session.clear
			end

			alias_method :get_current_user, :authorized?
		end

		def self.registered(app)
			app.helpers SessionAuth::Helpers
		end
	end

	register SessionAuth
end
