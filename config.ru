require_relative './routes/login_routes'
require_relative './routes/hashtag_routes'
require_relative './routes/user_routes'
require_relative './routes/followership_routes'
require_relative './routes/tweet_routes'
require_relative './routes/api_routes'

run Rack::URLMap.new({
	'/' => LoginRoutes,
	'/hashtags' => HashtagRoutes,
	'/user' => UserRoutes,
	'/follows' => FollowershipRoutes,
	'/tweets' => TweetRoutes,
	'/api/v1' => ApiRoutes
})
