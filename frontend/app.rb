# myapp.rb
require 'sinatra'
require 'rubygems'

get '/' do
	File.read(File.join('public', 'index.html'))
end


