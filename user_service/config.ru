require_relative './service.rb'
ENV['SINATRA_ENV'] ||= 'development'


run Sinatra::Application


