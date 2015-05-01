require 'sinatra/base'
require_relative '../helpers/redis_helper'
require_relative '../helpers/db_helper'

class ApiUserRoutes < Sinatra::Base
	include RedisConnect
	include Database

	get '/' do
		query = 'SELECT username, id, count from user_stats'
		get_from_redis(query){DB[query].all.to_json}
	end


end
