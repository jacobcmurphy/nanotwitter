require_relative './../routes/api_followership_routes.rb'
require 'minitest/autorun'
require 'rack/test'

describe "service" do
	include Rack::Test::Methods

	def app
    ApiUserRoutes
	end

	before do
		# empty out user table
    # create a Test user
	end

	describe "GET on /" do
    it "should return 200" do
      get '/'
      last_response.must_equal 200
    end
  end
end
