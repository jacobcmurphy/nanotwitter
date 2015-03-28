require 'sinatra/base'
require 'sinatra/activerecord'
require_relative './../helpers/auth'
require_relative "../models/followership"

class FollowershipRoutes < Sinatra::Base
	enable :sessions
	register Sinatra::SessionAuth
	register Sinatra::ActiveRecordExtension

	# get all followers of user with user_id
	get '/:user_id' do
		results = {}
		results[:user_id] = params[:user_id]
		results[:followees] = Followership.where(user_id: params[:user_id]).select("followee_id").map{|followership| followership.followee_id}
		if results[:followees].empty?
			status 404
			{"error": "user not found"}.to_json
		else
			status 200
			results.to_json
		end
	end

	# create a followership 
	post '/' do
		user_id = params[:user_id]
		followee_id = params[:followee_id]

		followership = Followership.create(user_id: user_id, followee_id: followee_id)
		if followership.valid?
			status 201
			redirect back
		else
			status 500
			followership.errors.to_json
		end
	end
end
