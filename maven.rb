require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'

get '/' do
  "hello"
end