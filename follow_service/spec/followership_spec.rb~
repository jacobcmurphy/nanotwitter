require_relative './../routes/followership_routes.rb'
require_relative './../models/followership.rb'
require 'rspec'
require 'rack/test'


def app
	FollowershipRoutes
end

include Rack::Test::Methods

describe "service" do

	before(:each) do
		Followership.delete_all
	end

	describe "GET on /followerships" do
		before :each do
				Followership.create(user_id: 1, followee_id: 2)
				Followership.create(user_id: 1, followee_id: 3)
		end

		it "should get followers" do
			get '/1'
			expect(last_response.status).to eq(200)

			attributes = JSON.parse(last_response.body)
			expect(attributes["user_id"]).to eq("1")
			expect(attributes["followees"]).to eq([2,3])
		end

		it "should return 404" do
			get '/5'
			expect(last_response.status).to eq(404)
		end
	end


	describe "POST on /followerships/1" do
		it "should add a follower" do
			post '/1', {followee_id: 4}
			expect(last_response.status).to eq(201)
			
			attributes = JSON.parse(last_response.body)
			expect(attributes).to have_key("followee_id")
		end
	end
end
