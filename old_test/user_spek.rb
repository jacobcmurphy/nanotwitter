require_relative './../routes/user_routes.rb'
require 'minitest/autorun'
require 'rack/test'

describe "service" do 
	include Rack::Test::Methods

	def app 
		UserRoutes
	end

	before(:each) do
		User.delete_all
	end

	describe "GET on /users/:id" do 
		let(:user_id) { 
			User.create(:name => "paul",
						:username => "PaulU",
						:email => "paul@pauldix.net", 
						:password => "strongpass").id
		}

		it "should return a user by id" do
			get "/#{user_id.to_s}"
			last_response.status.must_equal 200
			attributes = JSON.parse(last_response.body) 
			attributes["name"].must_equal "paul"
			attributes["username"]).must_equal "PaulU"
		end

		it "should not return a user with an email" do
			get "/#{user_id.to_s}"
			last_response.status.must_equal 200
			attributes = JSON.parse(last_response.body) 
			attributes.wont_include "email"
		end

		it "should not return a user's password" do 
			get "/#{user_id.to_s}"
			last_response.status.must_equal 200
			attributes = JSON.parse(last_response.body) 
			attributes.wont_include "password"
		end

		it "should return a 404 for a user that doesn't exist" do 
			get '/12342356' 
			last_response.status.must_equal 404
		end 
	end


	describe "POST on /api/v1/users" do 
		it "should create a user" do
			post('/', 
				 { :name => "trotter",
				   :username => "trotterU",
				   :email => "no spam",
				   :password => "whatever"}.to_json)

			last_response.status.must_equal 201
			user_id = JSON.parse(last_response.body)["id"]

			get "/#{user_id.to_s}"
			attributes = JSON.parse(last_response.body) 
			attributes["name"].must_equal "trotter"
			attributes["username"].must_equal "trotterU"

		end 
	end


	describe "POST on /api/v1/users/login" do 
		before(:each) do
			User.create(:name => "josh",
						:username => "JoshU",
						:password => "testpass") 
		end

		it "should return the user object on valid credentials" do 
			post('/login', 
				 { :username => "JoshU",
				   :password => "testpass"}.to_json )

			last_response.status.must_equal 201
			attributes = JSON.parse(last_response.body) 
			attributes["name"].must_equal "josh"
		end

		it "should fail on invalid credentials" do 
			post '/login', 
				 { :username => "JoshU",
				   :password => "badpass"}.to_json

			last_response.status.must_equal 400
		end 
	end  
end

