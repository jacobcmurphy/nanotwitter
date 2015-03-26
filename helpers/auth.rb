require 'sinatra/base'
require_relative './../models/user'

module Sinatra
	module SessionAuth
		module Helpers
			def authorized?
				@current_user = User.find(username: session[:username], password: session[:password])
				return @current_user
			end

			def authorize!
				redirect '/login' unless authorized?
			end

			def logout!
				session.clear
			end
		end

		def self.registered(app)
			app.helpers SessionAuth::Helpers
		end
	end

	register SessionAuth
end
