require 'sinatra'
require 'sequel'
require 'json'

tweets = Sequel.connect(ENV['database']).from(:tweets)

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

get '/tweet' do						#allows to search by user
	user = params[:user]
	"#{tweets.where(:user => user).all()}"
end
