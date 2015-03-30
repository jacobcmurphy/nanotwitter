source 'https://rubygems.org'
ruby '2.2.0'
gem 'puma'
gem 'sinatra'
gem 'activerecord'
gem "sinatra-activerecord"
gem 'faker'
gem 'newrelic_rpm'
#gem 'sinatra-cross_origin'

group :production do
	gem 'pg'
end

group :development, :test do
	gem 'sqlite3'
end

group :test do
	gem 'rack-test'
end
