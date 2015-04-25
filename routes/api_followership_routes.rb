require 'sinatra/base'


class ApiFollowershipRoutes < Sinatra::Base

	DB = Sequel.connect(:adapter => 'postgres', :host => 'localhost', :database => 'postgres', :user => 'edenzik')
	# get all followers of user with user_id
	get '/to/:id' do
		puts params[:id]
		return DB["SELECT * FROM users_followers WHERE followee_id = ?",params[:id]].to_json
	end

	get '/from/:id' do
		return DB["SELECT * FROM users_followers WHERE follower_id = ?",params[:id]].to_json
	end

	post '/to/:id' do
		begin
			DB['INSERT INTO following(follower, followee) VALUES((SELECT id FROM users where email=? AND password=?), ?)', params[:email],params[:password], params[:id]].insert
			return {:status => "OK"}.to_json
		rescue
			return {:status => "FAILED"}.to_json
		end
	end

	delete '/to/:id' do
		begin
			DB['DELETE FROM following WHERE (SELECT id FROM users where email=? AND password=?)=follower AND followee=?', params[:email],params[:password], params[:id]].insert
			return {:status => "OK"}.to_json
		rescue
			return {:status => "FAILED"}.to_json
		end
	end




	delete 'to/:id' do
		puts "tada"
	end

end
