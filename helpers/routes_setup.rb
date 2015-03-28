enable :sessions
enable :cross_origin
register Sinatra::SessionAuth
register Sinatra::CrossOrigin

options "*" do
	  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"

	    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

		  200
end

set :views, File.expand_path('../../views', __FILE__)
