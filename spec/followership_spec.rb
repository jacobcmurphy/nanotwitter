require_relative './../routes/followership_routes.rb'
require 'minitest/autorun'
require 'rack/test'

describe "service" do
	include Rack::Test::Methods

	def app
		FollowershipRoutes
	end


	before do
		Followership.delete_all
	end

	describe "GET on /followerships" do
		before do
				Followership.create(user_id: 1, followee_id: 2)
				Followership.create(user_id: 1, followee_id: 3)
		end

		it "should get followers" do
			get '/1'
			last_response.status.must_equal 200

			attributes = JSON.parse(last_response.body)
			attributes["user_id"].must_equal "1"
			attributes["followees"].must_equal [2,3]
		end

		it "should return 404" do
			get '/5'
			last_response.status.must_equal 404
		end
	end


	describe "POST on /followerships/1" do
		it "should add a follower" do
			post '/1', {followee_id: 4}.to_json
			last_response.status.must_equal 201
			
			attributes = JSON.parse(last_response.body)
			attributes.must_include "followee_id"
		end
	end
end
