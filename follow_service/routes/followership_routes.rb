require 'sinatra/base'
require 'sinatra/activerecord'
require_relative "../models/followership"

class FollowershipRoutes < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	# get all followers of user with user_id
	get '/:user_id' do
		results = {user_id: params[:user_id]}
		results[:followees] = Followership.where(user_id: params[:user_id]).select("followee_id").map{|followership| followership.followee_id}
		status 200
		results.to_json
	end

	# insert a new tag
	put '/:user_id' do
		followership = Followership.create(user_id: params[:user_id], followee_id: params[:followee_id]) if params[:followee_id]
		status 201
		followership.to_json
	end
			
end
