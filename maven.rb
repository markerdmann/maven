require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'

configure do
  require 'redis'
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/' do
  "hello bitches"
end
