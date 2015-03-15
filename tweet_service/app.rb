require 'sinatra'
require 'sequel'
require 'json'
require 'sinatra/cross_origin'
Sequel.quote_identifiers = false
dbloc = ENV['database'] || 'sqlite://dev.db'

db = Sequel.connect(dbloc)
tweets = db.from(:tweets)

configure do
  enable :cross_origin
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"
  
  # Needed for AngularJS
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  
  200
end

post '/tweet' do					#if post at /tweet
	tweet = JSON.parse request.body.read		#receives tweet
	tweet['created_at'] = Time.now			#adds timestamp
	begin
		tweets.insert(tweet)			#inserts tweet
		200					#good response
	rescue
		400					#malformed
	end
end

get '/all' do						#gets all tweets
	"#{tweets.limit(50).all()}"
end

post '/get_tweets_for' do				#if post at /read
	req = JSON.parse request.body.read		#receives tweet
	begin
		"#{tweets.where([[:user_id, req['users']]]).limit(50).order(:created_at).reverse().all()}"
	rescue
		400					#malformed
	end
end


