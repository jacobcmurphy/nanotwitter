require 'sinatra/base'
require 'sinatra/activerecord'
require_relative '../models/user'

class ApiUserRoutes < Sinatra::Base
	NUMBER_OF_TWEETS = 100
	register Sinatra::ActiveRecordExtension

	get '/:id' do
		begin
			user = User.find(params[:id])
			if user
				status 200
				user.to_json(only: [:id, :name, :username])
			else
				status 404
				{"Message" => "No user exists with that id."}.to_json
			end
		rescue => e
			status 500
			e.to_json
		end
	end

	get '/:id/tweets' do
		begin
			date = (params[:date]) ? DateTime.parse(params[:date]) : Time.now.to_datetime
			tweets = Tweet.where(['user_id = ? and created_at < ?', params[:id].to_i, date]).order(created_at: :desc).limit(NUMBER_OF_TWEETS)
			if tweets.size > 0
				status 200
				tweets.to_json
			else
				status 404
				[].to_json
			end
		rescue => e
			status 500
			e.to_json
		end
	end

	# list of user's follower's tweets
	get '/:id/feed' do
		@tweets = ActiveRecord::Base.connection.exec_query %Q(
				SELECT followees.id, followees.name, followees.username, tweets.text, tweets.created_at
				FROM users
				JOIN followerships ON followerships.user_id = users.id
				JOIN users AS followees ON followees.id = followerships.followee_id
				JOIN tweets ON tweets.user_id = followees.id
				WHERE users.id = #{params[:id]} 
				ORDER BY tweets.created_at DESC
				LIMIT #{NUMBER_OF_TWEETS})
		@tweets = @tweets.rows

		if @tweets
			@tweets.to_json	
		else
			[].to_json
		end
	end

	# list of people following user
	get '/:id/following' do
		@user = User.find(params[:id])
		if @user
			status 200
			@user.followees.to_json
		else
			status 404
			[].to_json
		end
	end

	# list of user's followers
	get '/:id/followers' do
		@user = User.find(params[:id])
		if @user
			status 200
			@user.followers.to_json
		else
			status 404
			[].to_json
		end
	end

	# follow user with :id
	post '/:id/followers' do
		json_params = JSON.parse request.body
		follower = User.find(json_params["id"])
		if follower && follower.password == json_params["password"]
			followership = Followership.create(user_id: follower.id, followee_id: params[:id] )
			status 201 if followership.errors.empty?
		else
			status 500
		end
	end

	delete '/:id/followers' do
		json_params = JSON.parse request.body
		follower = User.find(json_params["id"])
		if follower && follower.password == json_params["password"]
			followership = Followership.delete(user_id: follower.id, followee_id: params[:id] )
			status 200 if followership.errors.empty?
		else
			status 500
		end

	end

	# list of all users
	get '' do
		@users = User.all

		if @users
			status 200
			@users.to_json
		else
			status 404
			[].to_json
		end
	end

end
