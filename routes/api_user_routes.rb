require 'sinatra/base'
require_relative '../helpers/redis_helper'

class ApiUserRoutes < Sinatra::Base
	include RedisConnect
	DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'postgres', :user => 'edenzik')

	get '/' do
		query = 'SELECT username, id, count from user_stats'
		get_from_redis(query){DB[query].all.to_json}

		# if r.get(query).nil?
		# 	result = DB[query].all().to_json()
		# 	r.set(query, result)
		# 	r.expire(query,10)
		# 	return result
		# end
		# return r.get(query)
	end


end
