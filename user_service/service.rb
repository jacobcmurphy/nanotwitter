require 'rubygems' 
require 'active_record' 
require 'sinatra' 
require 'sinatra/jsonp'
require_relative 'models/user'

# setting up the environment
env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1] if env_index

env = env_arg || ENV["SINATRA_ENV"] || "development" 
databases = YAML.load_file("config/database.yml") 
ActiveRecord::Base.establish_connection(databases[env])


get '/api/v1/users/:id' do
  user = User.find_by_id(params[:id]) 
  if user 
    vals = { :id => user.id, :name => user.name, :username => user.username }
    jsonp(vals)
  else
    error 404, jsonp({:error => "user not found"})
  end
end


# create a new user
post '/api/v1/users' do
  begin
    user = User.create(JSON.parse(request.body.read)) 
    if user.valid?
      jsonp(user.as_json)
    else
      error 400, jsonp(user.errors)
    end
  rescue => e
    error 400, jsonp(e.message)
  end
end

# verify a user name and password 
post '/api/v1/users/login' do
  begin
    attributes = JSON.parse(request.body.read) 
    user = User.find_by(:username => attributes["username"],
                        :password => attributes["password"]) 
    if user
      jsonp(user.as_json)
    else
      error 400, jsonp({:error => "invalid login credentials"})
    end
  rescue => e
    error 400, jsonp(e.message)
  end 
end
