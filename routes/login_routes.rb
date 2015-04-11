require 'sinatra/base'
require 'json'
require_relative './../helpers/auth'
require 'sinatra/cross_origin'


class LoginRoutes < Sinatra::Base

	enable :sessions
	set :public_folder, 'public'
	register Sinatra::SessionAuth

	get '/' do
		connection = ActiveRecord::Base.connection
		redirect '/index.html'	
	end

	post '/login' do
		content_type :json
		begin 
			return {:id => User.find_by(:email => params["email"], :password => params["password"]).id, :status => "OK"}.to_json
		rescue
			return {:status => "FAIL"}.to_json
		end
	end

	# sign up 
	post '/register' do
		content_type :json
		begin
			return {:id => User.create(:username => params['handle'], :email => params['email'], :password => params['password']).id}.to_json
		rescue 
			return {:status => "FAIL"}.to_json
		end
	end

	post '/tweet' do
		content_type :json
		Tweet.create(text: params[:text], user_id: params[:id]).to_json
		status 200
	end


	get '/logout' do
		logout!
		redirect to '/login'
	end


	get '/all' do
		sql = "select username, text from tweets, users WHERE users.id = tweets.user_id ORDER BY tweets.created_at DESC limit 50 "
		ActiveRecord::Base.connection.execute(sql).to_json()
	end

	get '/users' do
		sql = "select users.id AS id, users.username, COUNT(followerships.followee_id) AS count from users LEFT OUTER JOIN followerships ON followerships.user_id = users.id GROUP BY users.username;"
		ActiveRecord::Base.connection.execute(sql).to_json()
	end

	get '/get_followers/:user' do
		sql = "select users.username, COUNT(followerships.followee_id) AS count from users LEFT OUTER JOIN followerships ON followerships.user_id = users.id WHERE users.id = #{params['user']} GROUP BY users.username;"
		return ActiveRecord::Base.connection.execute(sql).to_json()
	end

	
	get '/search/:term' do
		query = "text LIKE '%" + params['term'].gsub("\"","") + "%'"
		return Tweet.where(query).to_json()
	end

	post '/follow' do
		Followership.create(:user_id => params[:user_id], :followee_id => params[:followee_id])
		return {:status => "OK"}.to_json();
	end

	post '/unfollow' do
		Followership.where(user_id: params[:user_id], followee_id: params[:followee_id]).destroy_all;
		return {:status => "OK"}.to_json();
	end



end

