require 'sinatra/base'


class ApiUserRoutes < Sinatra::Base
	DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'postgres', :user => 'edenzik')
	
	get '/' do
		return DB['SELECT username, id from users'].all().to_json()
	end


end
