require_relative './../routes/hashtag_routes.rb'
require 'minitest/autorun'
require 'rack/test'

describe "service" do
	include Rack::Test::Methods

	def app
		HashtagRoutes
	end

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
			last_response.status.must_equal 200

			attributes = JSON.parse(last_response.body)
			attributes["tag"].must_equal "test"
			attributes["tweet_ids"].must_equal [1,2,3]
		end

		it "should return 404" do
			get '/5'
			last_response.status.must_equal 404
		end
	end


	describe "POST on /hashtags/test" do
		it "should add a hashtag" do
			post '/tester', {tweet_id: 4}
			last_response.status.must_equal 201
			
			attributes = JSON.parse(last_response.body)
			attributes.must_include "tweet_id"
		end
	end
end
