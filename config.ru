require_relative './routes/login_routes'
require_relative './routes/hashtag_routes'
require_relative './routes/user_routes'
require_relative './routes/followership_routes'
require_relative './routes/tweet_routes'

ENV['SINATRA_ENV'] ||= 'development'

run Rack::URLMap.new({
	'/' => LoginRoutes,
	'/hashtags' => HashtagRoutes,
	'/users' => UserRoutes,
	'/follows' => FollowershipRoutes,
	'/tweets' => TweetRoutes
})
