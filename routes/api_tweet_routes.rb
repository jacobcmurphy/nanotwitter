require 'sinatra/base'
require 'json'

class ApiTweetRoutes < Sinatra::Base
	DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'postgres', :user => 'edenzik')

	get '/:id' do
		return DB[:tweets_users].filter(:id => params[:id]).limit(10).to_json
	end

	get '/search/:term' do
		puts params[:term]
		return DB["SELECT * FROM tweets_users WHERE text LIKE '%'||?||'%'",params[:term]].to_json
	end


	get '/' do
		DB[:tweets_users].order(:created).reverse().limit(50).to_json
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
