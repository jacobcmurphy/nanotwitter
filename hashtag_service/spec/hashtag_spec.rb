require_relative './../routes/hashtag_routes.rb'
require_relative './../models/hashtag.rb'
require 'rspec'
require 'rack/test'


def app
	HashtagRoutes
end

include Rack::Test::Methods

describe "service" do

	before(:each) do
		Hashtag.delete_all
	end

	describe "GET on /hashtags" do
		before :each do
				Hashtag.create(tag: "test", tweet_id: 1)
				Hashtag.create(tag: "test", tweet_id: 2)
				Hashtag.create(tag: "test", tweet_id: 3)
		end

		it "should get hashtag" do
			get '/test'
			expect(last_response.status).to eq(200)

			attributes = JSON.parse(last_response.body)
			expect(attributes["tag"]).to eq("test")
			expect(attributes["tweet_ids"]).to eq([1,2,3])
		end

		it "should return 404" do
			get '/5'
			expect(last_response.status).to eq(404)
		end
	end


	describe "POST on /hashtags/test" do
		it "should add a hashtag" do
			post '/tester', {tweet_id: 4}
			expect(last_response.status).to eq(201)
			
			attributes = JSON.parse(last_response.body)
			expect(attributes).to have_key("tweet_id")
		end
	end
end
