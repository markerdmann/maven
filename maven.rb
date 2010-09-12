require 'rubygems'
require 'bundler'
require 'erb'

Bundler.setup

require 'sinatra'

get '/' do
  erb :home
end

#get '/friend/:userid' do
 #   "#{params[:name]}"
#end
