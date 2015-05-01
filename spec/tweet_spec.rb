require_relative './../routes/api_tweet_routes.rb'
require 'minitest/autorun'
require 'rack/test'

describe "service" do
	include Rack::Test::Methods

	def app
    ApiTweetRoutes
	end

	before do
		# empty out tweet table
    # create a tweet with word "test"
	end

	describe "GET on /:id" do
    it "should return 200" do
      get '/1'
      last_response.must_equal 200
    end
  end

  describe "GET on /search/:term" do
    it "should return 200" do
      get '/search/test'
      last_response.must_equal 200
    end
  end

  describe "GET on /to/:id" do
    it "should return 200" do
      get '/100002'
      last_response.must_equal 200
    end
  end

  describe "GET on /" do
    it "should return 200" do
      get '/'
      last_response.must_equal 200
    end
  end

  describe "POST on /" do
    it "should add tweet" do
      post '/', {text: "Random post", email: "test@example.com", password: "testtest"}
      last_response.body.must_include "OK"
    end

    it "should not add tweet" do
      post '/', {text: "Random post", email: "test@example.com", password: "badtesttest"}
      last_response.body.must_include "FAILED"
    end
  end
end
