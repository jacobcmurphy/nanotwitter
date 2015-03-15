require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/cross_origin'
require_relative "../models/followership"

class FollowershipRoutes < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::CrossOrigin

  configure do
    enable :cross_origin
  end

  options "*" do
    response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Methods"] = "HEAD,GET,PUT,DELETE,OPTIONS"
    
    # Needed for AngularJS
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    
    200
  end
  
  # get all followers of user with user_id
  get '/:user_id' do
    cross_origin
    results = {user_id: params[:user_id]}
    results[:followees] = Followership.where(user_id: params[:user_id]).select("followee_id").map{|followership| followership.followee_id}
    status 200
    results.to_json
  end

  # insert a new tag
  put '/:user_id' do
    cross_origin
    user_id_val = params[:user_id]
    followee_id_val = JSON.parse(request.body.read)["followee_id"]

    followership = Followership.create(user_id: user_id_val, followee_id: followee_id_val)
    status 201
    followership.to_json
  end
  
end
