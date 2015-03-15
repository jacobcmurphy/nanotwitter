require 'sinatra'
require 'sequel'
require 'json'
require 'sinatra/cross_origin'

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
  #puts DB.from(:tweets).all()
  tweet = JSON.parse request.body.read		#receives tweet
  tweet['created_at'] = Time.now			#adds timestamp
  begin
    tweets.insert(tweet)			#inserts tweet
    200					#good response
  rescue
    400					#malformed
  end
end

get '/recent' do
  puts "doing fetch"
  begin
    db.fetch("SELECT * FROM tweets ORDER BY created_at LIMIT 20").all().to_json

  rescue
    "{}"
  end
end

get '/tweet' do						#allows to search by user

	user = params[:user]
	top = params[:top]
	begin
		if user 
			"#{tweets.where(:user => user).all()}" 
		elsif top 
			"#{tweets.limit(top).all()}"
		end
	rescue
		400
	end
	

end

