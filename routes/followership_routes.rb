require 'sinatra/base'
require 'sinatra/activerecord'
require_relative "../models/followership"

class FollowershipRoutes < Sinatra::Base
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

  # insert a new tag
  post '/:user_id' do
    user_id = params[:user_id]
    followee_id = JSON.parse(request.body.read)['followee_id']

    followership = Followership.create(user_id: user_id, followee_id: followee_id)
    if followership.valid?
      status 201
      followership.to_json
    else
      status 500
      followership.errors.to_json
    end
  end
end
