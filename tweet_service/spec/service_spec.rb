require ENV['app']
require 'rspec'
require 'rack/test'

set :environment, :test

def app
	Sinatra::Application
end


RSpec.configure do |config|
	config.include Rack::Test::Methods
end

describe "POST to /tweet" do
	it "should be able to post a new tweet" do
		post('/tweet', { :user_id => rand(9999999999999),
		   :content => "this is a test tweet"}.to_json)
		expect(last_response.status).to eq(200)
	end
	it "should be able to commit a new tweet to the database" do
		user_id = rand(9999999999999)
		post('/tweet', { :user_id => user_id,
		   :content => "this is a test tweet"}.to_json)
		post('/get_tweets_for', { :users => user_id}.to_json)
		puts last_response.body
		expect(last_response.status).to eq(200)
		expect(last_response.body).not_to eq('[]')
	end

end

describe "POST to /get_tweets_for" do
	it "should be able to get tweets from multiple users" do
		user1 = rand(9999999999999)
		user2 = rand(9999999999999)
		user3 = rand(9999999999999)
		post('/tweet', { :user_id => user1,
		   :content => "this is a test tweet"}.to_json)
		post('/tweet', { :user_id => user2,
		   :content => "this is a test tweet"}.to_json)
		post('/tweet', { :user_id => user3,
		   :content => "this is a test tweet"}.to_json)
		post('/get_tweets_for', { :users => [user1,user2,user3]}.to_json)
		expect(last_response.status).to eq(200)
		expect(last_response.body).not_to eq('[]')
	end
end

describe "GET from /all" do
	it "should be able to get 50 latest tweets from server" do
		get('/all')
		expect(last_response.status).to eq(200)
		expect(last_response.body).not_to eq('[]')
	end
end



