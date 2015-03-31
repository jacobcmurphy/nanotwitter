source 'https://rubygems.org'
ruby '2.1.0', :engine => "rbx", :engine_version => "2.4.1"
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
