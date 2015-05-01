require_relative './../routes/base_routes.rb'
require 'minitest/autorun'
require 'rack/test'

describe "service" do
	include Rack::Test::Methods

	def app
    BaseRoutes
	end

	before do
		#
	end

	describe "GET on /" do
    it "should return 200" do
      get '/'
      last_response.must_equal 200
    end
  end

  describe "GET on /test_tweet" do
    it "should add test tweet" do
      get '/'
      last_response.body.must_include "Confirmed"
    end
  end

  describe "GET on /test_follow" do
    it "should add a test follow" do
      get '/test_follow'
      last_response.body.must_include "Confirmed"
    end
  end

  describe "GET on /reset" do
    it "should reset test data" do
      get '/reset'
      last_response.body.must_include "Confirmed"
    end
  end
end
