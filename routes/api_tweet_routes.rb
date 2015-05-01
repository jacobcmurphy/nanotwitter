require 'sinatra/base'
require_relative '../helpers/redis_helper'
require_relative '../helpers/db_helper'

class ApiTweetRoutes < Sinatra::Base
	include RedisConnect
	include Database

	get '/:id' do
		get_from_redis(params[:id]){ DB[:tweets_users].filter(id: params[:id]).limit(10).all.to_json }
	end

	get '/search/:term' do
		get_from_redis(params[:term]){DB["SELECT * FROM tweets_users WHERE text LIKE '%'||?||'%'",params[:term]].limit(100).all.to_json}
	end

	get '/to/:id' do
		query = 'SELECT * FROM tweets_users, following WHERE followee=id AND follower=?'
		get_from_redis(query){DB[query,params[:id]].order(:created).reverse().limit(100).all.to_json}
	end


	get '/' do
		get_from_redis(:tweets_users){DB[:tweets_users].order(:created).reverse().limit(100).all.to_json}
	end

	post '/' do
		begin
			DB['INSERT INTO tweets(text, user_id) VALUES(?, (SELECT id FROM users where email=? AND password=?))',params[:text],params[:email],params[:password]].insert
			return {status: "OK"}.to_json
		rescue
			return {status: "FAILED"}.to_json
		end
	end

end
