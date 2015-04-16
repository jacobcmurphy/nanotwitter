require 'sinatra'
require 'json'

class LoginRoutes < Sinatra::Base

	set :public_folder, 'public'

	# loader.io validation endpoint
	get 'loaderio-3a56c6f3181bf46c14582978f30c3c83' do
		status 200
	end

	get '/' do
		connection = ActiveRecord::Base.connection
		redirect '/index.html'	
	end



	post '/login' do
		user = User.find_by(:email => params[:email])
		if !user
		#	status 403
			return {:STATUS => "NOT FOUND"}.to_json
		end
		if user.password == params[:password]
			status 200
			return {:STATUS => "OK"}.to_json
		end
		status 403
		return {:STATUS => "BAD PASSWORD"}.to_json
	end

	# sign up 
	post '/register' do
		if User.exists?(email: params[:email], username: params[:username])
			return {:STATUS => "USER EXISTS"}.to_json
		end
		if User.create(email: params[:email], password: params[:password], username: params[:username])
			status 200
			return {:STATUS => "USER CREATED"}.to_json
		end
		status 403
		return {:STATUS => "FAILED"}.to_json
	end

	post '/tweet' do
		content_type :json
		if User.exists?(email: params[:email], password: params[:password])
			Tweet.create(text: params[:text], user_id: params[:id]).to_json
			status 200
		end
		status 403
		
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

