require 'sinatra/base'
require_relative '../helpers/redis_helper'

class ApiTweetRoutes < Sinatra::Base
	include RedisConnect

	DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'postgres', :user => 'edenzik')

	get '/:id' do
		get_from_redis(params[:id]){ DB[:tweets_users].filter(:id => params[:id]).limit(10).all.to_json }
		# if r.get(params[:id]).nil?
		# 	result =  DB[:tweets_users].filter(:id => params[:id]).limit(10).all.to_json
		# 	r.set(params[:id],result)
		# 	r.expire(params[:id],10)
		# 	return result
		# end
		# return r.get(params[:id])
	end

	get '/search/:term' do
		get_from_redis(params[:term]){DB["SELECT * FROM tweets_users WHERE text LIKE '%'||?||'%'",params[:term]].limit(100).all.to_json}
		# if r.get(params[:term]).nil?
		# 	result = DB["SELECT * FROM tweets_users WHERE text LIKE '%'||?||'%'",params[:term]].limit(100).all.to_json
		# 	r.set(params[:term],result)
		# 	r.expire(params[:term],10)
		# 	return result
		# end
		return r.get(params[:term])
	end

	get '/to/:id' do
		query = 'SELECT * FROM following, tweets WHERE follower=? AND tweets.user_id = followee'
		get_from_redis(query){DB[query,params[:id]].order(:created).reverse().limit(100).all.to_json}
		# if r.get(query).nil?
		# 	result = DB[query,params[:id]].order(:created).reverse().limit(100).all.to_json
		# 	r.set(query, result)
		# 	r.expire(query,10)
		# 	return result
		# end
		# return r.get(query)
	end


	get '/' do
		get_from_redis(:tweets_users){DB[:tweets_users].order(:created).reverse().limit(100).all.to_json}
		# query = :tweets_users
		# if r.get(query).nil?
		# 	result = DB[:tweets_users].order(:created).reverse().limit(100).all.to_json
		# 	r.set(query, result)
		# 	r.expire(query,10)
		# 	return result
		# end
		# return r.get(query)
	end

	post '/' do
		begin
			DB['INSERT INTO tweets(text, user_id) VALUES(?, (SELECT id FROM users where email=? AND password=?))',params[:text],params[:email],params[:password]].insert
			return {:status => "OK"}.to_json
		rescue
			return {:status => "FAILED"}.to_json
		end

	end

end
