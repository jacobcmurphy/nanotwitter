require 'sinatra'
require 'json'
require_relative '../helpers/db_helper'

class AccountRoutes < Sinatra::Base
	include Database

	post '/login' do
		user = DB[:users].select(:id, :password).where(email: params[:email], password: params[:password]).first
		if !user
			return {status: "NOT FOUND"}.to_json
		end
		if user[:password] == params[:password]
			status 200
			return {status: "OK", id: user[:id]}.to_json
		end
		return {status: "BAD PASSWORD"}.to_json
	end

	# sign up
	post '/register' do
		if !DB.fetch("SELECT * FROM users WHERE email = ? OR username = ?", params[:email],params[:username]).empty?
			return {status: "USER EXISTS"}.to_json
		end
		if DB[:users].insert(username: params[:username], password: params[:password], email: params[:email])
			user = DB[:users].select(:id, :password).where(email: params[:email], password: params[:password]).first
			status 200
			return {status: "USER CREATED", id: user[:id]}.to_json
		end
		return {status: "FAILED"}.to_json
	end


	get '/logout' do
		return {status: "OK"}.to_json
	end

end
