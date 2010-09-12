require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'oauth2'
require 'json'

configure do
  require 'redis'
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

def client
  OAuth2::Client.new('140998689277380', '25eb7d9c148183d465e3c1e48fafeade', 
  :site => 'https://graph.facebook.com'
  :parse_json => true)
end

get '/auth/facebook' do
  redirect client.web_server.authorize_url(
    :redirect_uri => redirect_uri, 
    :scope => 'email,offline_access'
  )
end

get '/auth/facebook/callback' do
  access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
  user = JSON.parse(access_token.get('/me'))

  user.inspect
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/auth/facebook/callback'
  uri.query = nil
  uri.to_s
end

get '/' do
  "hello bitches"
end
