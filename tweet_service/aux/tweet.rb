require 'twitter'
client = Twitter::Streaming::Client.new do |config|
	config.consumer_key        = "jtlS31wC95Xli3CZMO4OidTH1"
	config.consumer_secret     = "iCy6evhz0lGnOjNMCTnkxN5y9Cuh86ndyGpkIAX23HPIFCEdr3"
	config.access_token        = "74636828-qW06kurl1F2AtM2x23izzSCWWNUggpWkzjA2aqeJP"
	config.access_token_secret = "zsZR0CiT8PWkhOdSrXaVDRSVOWo4JuxOhjOmL2IkFz36o"
end
client.sample do |tweet|
	if tweet.is_a?(Twitter::Tweet)
		puts tweet.text
	end
end

