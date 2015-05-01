require 'sinatra/base'
require 'json'
require_relative '../helpers/redis_helper'
require_relative '../helpers/db_helper'

class ApiFollowershipRoutes < Sinatra::Base
	include RedisConnect
	include Database

	# get all followers of user with user_id
	get '/to/:id' do
		key = params[:id].to_str + "to"
		get_from_redis(key){DB["SELECT * FROM users_followers WHERE followee_id = ?",params[:id]].all.to_json}
		#
		# if r.get(key).nil?
		# 	result = DB["SELECT * FROM users_followers WHERE followee_id = ?",params[:id]].all.to_json
		# 	r.set(key, result)
		# 	r.expire(key, 10)
		# 	return result
		# end
		# return r.get(key)
	end

	get '/from/:id' do
		return DB["SELECT * FROM users_followers WHERE follower_id = ?", params[:id]].all.to_json
	end

	post '/to/:id' do
		begin
			DB['INSERT INTO following(follower, followee) VALUES((SELECT id FROM users where email=? AND password=?), ?)', params[:email],params[:password], params[:id]].insert
			return {status: "OK"}.to_json
		rescue
			return {status: "FAILED"}.to_json
		end
	end

	delete '/to/:id' do
		begin
			DB['DELETE FROM following WHERE (SELECT id FROM users where email=? AND password=?)=follower AND followee=?', params[:email],params[:password], params[:id]].insert
			return {status: "OK"}.to_json
		rescue
			return {status: "FAILED"}.to_json
		end
	end

end
