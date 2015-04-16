require 'newrelic_rpm'
require_relative './routes/login_routes'
require_relative './routes/hashtag_routes'
require_relative './routes/user_routes'
require_relative './routes/followership_routes'
require_relative './routes/tweet_routes'
require_relative './routes/api_tweet_routes'
require_relative './routes/api_user_routes'

run Rack::URLMap.new({
	'/' => LoginRoutes,
	'/hashtags' => HashtagRoutes,
	'/users' => UserRoutes,
	'/follows' => FollowershipRoutes,
	'/tweets' => TweetRoutes,
	'/api/v1/tweets' => ApiTweetRoutes,
	'/api/v1/users' => ApiUserRoutes
})
