require_relative './../routes/api_followership_routes.rb'
require 'minitest/autorun'
require 'rack/test'

describe "service" do
	include Rack::Test::Methods

	def app
    ApiFollowershipRoutes
	end

	before do
		# empty out following table
    # create a following
	end

	describe "GET on /to/:id" do
    it "should return 200" do
      get '/to/100002'
      last_response.must_equal 200
    end
  end

  describe "GET on /from/:id" do
    it "should return 200" do
      get '/from/100002'
      last_response.must_equal 200
    end
  end

  describe "POST on /to/:id" do
    it "should insert following" do
      post '/to/1', {email: "test@example.com", password: "testtest"}
      last_response.body.must_include "OK"
    end

    it "should fail" do
      post '/to/1', {email: "test@example.com", password: "badtesttest"}
      last_response.body.must_include "FAILED"
    end
  end

  describe "DELETE on /to/:id" do
    it "should delete following" do
      post '/to/1', {email: "test@example.com", password: "testtest"}
      last_response.body.must_include "OK"
    end

    it "should fail" do
      post '/to/1', {email: "test@example.com", password: "badtesttest"}
      last_response.body.must_include "FAILED"
    end
  end
end
