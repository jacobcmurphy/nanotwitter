require 'sinatra/base'
require 'json'
require 'redis'


class ApiTweetRoutes < Sinatra::Base
	DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'postgres', :user => 'edenzik')
	r = Redis.new


	get '/:id' do
		if r.get(params[:id]).nil?
			result =  DB[:tweets_users].filter(:id => params[:id]).limit(10).to_json
			r.set(params[:id],result)
			r.expire(params[:id],10)
			return result
		end
		return r.get(params[:id])
	end

	get '/search/:term' do
		if r.get(params[:term]).nil?
			result = DB["SELECT * FROM tweets_users WHERE text LIKE '%'||?||'%'",params[:term]].limit(50).all.to_json
			r.set(params[:term],result)
			r.expire(params[:term],10)
			return result
		end
		return r.get(params[:term])
	end


	get '/' do
		content_type :json
		puts DB['select * from users'].all()
		query = :tweets_users
		if r.get(query).nil?
			result = DB[:tweets_users].order(:created).reverse().limit(100).to_json
			r.set(query, result)
			r.expire(query,10)
			return result
		end
		return r.get(query)
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


