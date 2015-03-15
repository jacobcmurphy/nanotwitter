require_relative './routes/followership_routes'

ENV['SINATRA_ENV'] ||= 'development'


run Rack::URLMap.new({
	'/followerships' => FollowershipRoutes
})
