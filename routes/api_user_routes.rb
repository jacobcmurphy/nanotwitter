require 'sinatra/base'
require 'redis'


class ApiUserRoutes < Sinatra::Base
	DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'postgres', :user => 'edenzik')
	r = Redis.new
	
	get '/' do
		query = 'SELECT username, id, count from user_stats'
		if r.get(query).nil?
			result = DB[query].all().to_json()
			r.set(query, result)
			r.expire(query,10)
			return result
		end
		return r.get(query)
	end


end
