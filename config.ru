require_relative './routes/base_routes'
require_relative './routes/account_routes'
require_relative './routes/api_hashtag_routes'
require_relative './routes/api_followership_routes'
require_relative './routes/api_tweet_routes'
require_relative './routes/api_user_routes'

run Rack::URLMap.new({
	'/' => BaseRoutes,
	'/account' => AccountRoutes,
	'/api/v1/follow' => ApiFollowershipRoutes,
	'/api/v1/tweet' => ApiTweetRoutes,
	'/api/v1/user' => ApiUserRoutes,
	'/api/v1/hashtag' => ApiHashtagRoutes
})
