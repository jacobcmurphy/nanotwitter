require 'sinatra'
require 'sequel'
require 'json'
require 'sinatra/cross_origin'
Sequel.quote_identifiers = false
db = Sequel.connect(:adapter=>'postgres', :host=>'ec2-107-22-253-198.compute-1.amazonaws.com', :database=>'dd05tn6063hgsb', :user=>'iyqmrjwllheyvy', :password=>'68t2Sk9xEw4CsfDRE2g_N6uz9C')
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

post '/tweet' do				#if post at /tweet
  tweet = JSON.parse request.body.read		#receives tweet
  tweet['created_at'] = Time.now			#adds timestamp
  begin
    tweets.insert(tweet)			#inserts tweet
    200					#good response
  rescue => e
    puts e
    400					#malformed
  end
end

get '/all' do						#gets all tweets
  "#{tweets.limit(50).order(:created_at).reverse().all().to_json()}"
end

post '/get_tweets_for' do				#if post at /read
  req = JSON.parse request.body.read		#receives tweet
  begin
    "#{tweets.where([[:user_id, req['users']]]).limit(50).order(:created_at).reverse().all().to_json()}"
  rescue
    400					#malformed
  end
end



