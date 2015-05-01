require_relative './../routes/account_routes.rb'
require 'minitest/autorun'
require 'rack/test'

describe "service" do
	include Rack::Test::Methods

	def app
		AccountRoutes
	end

	before do
		# empty out user table
	end

	describe "POST on /login" do
		it "should login" do
			post '/login', {password: "testtest", email: "test@example.com"}
			last_response.body.must_include "OK"
		end

		it "should be a bad password" do
			post '/login', {password: "testtest-bad", email: "test@example.com"}
			last_response.body.must_include "BAD PASSWORD"
		end

		it "should have an unfound user" do
			post '/login', {password: "testtest", email: "faketest-asdfgrtgbvcdsertg@example.com"}
			last_response.body.must_include "NOT FOUND"
		end
	end

	describe "POST on /register" do
		it "should have user already existing" do
			post '/register', {password: "testtest", email: "test@example.com"}
			last_response.body.body.must_include "EXISTS"
		end

		it "should fail" do
			post '/register', {password: "testtest", email: "test@example.com"}
			last_response.body.must_include "FAILED"
		end

		it "should succeed" do
			post '/register', {password: "newtesttest", email: "newtest@example.com"}
			last_response.body.must_include "USER CREATED"
		end
	end

	describe "GET on /logout" do
		it "should work" do
			get '/logout'
			last_response.body.must_include "OK"
		end
	end

end
