require_relative './routes/hashtag_routes'

ENV['SINATRA_ENV'] ||= 'development'

run Rack::URLMap.new({
	'/hashtags' => HashtagRoutes,
})
