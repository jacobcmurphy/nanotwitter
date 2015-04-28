require 'sinatra'
require 'json'
require 'sequel'
require 'redis'

class BaseRoutes < Sinatra::Base
	set :public_folder, 'public'
	r = Redis.new

	# loader.io validation endpoint
	get 'loaderio-3a56c6f3181bf46c14582978f30c3c83' do
		status 200
	end

	get 'loaderio-feafc7f9426987c407a62f6375f1c865' do
		status 200
	end

	# loader.io validation endpoint
	get 'loaderio-211ffded21975d2a7404c4d83638692b' do
		status 200
	end

	get '/' do
		if r.get(:main).nil?
			puts "yes"
			result =  File.read(File.join('public', 'index.html'))
			r.set(:main,result)
			return result
		end
		return r.get(:main)
		#redirect '/index.html'	
	end

end

