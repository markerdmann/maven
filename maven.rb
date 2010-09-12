require 'rubygems'
require 'bundler'
require 'erb'

Bundler.setup

require 'sinatra'
require 'oauth2'
require 'json'

enable :sessions

configure do
  require 'redis'
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/login' do
  erb :login
end

post '/login' do
  password = REDIS.get("users:#{params[:username]}")
  if password == params[:password]
    session[:user] = Digest::MD5.hexdigest(password)
  elsif password == nil
    REDIS.set("users:#{params[:username]}", params[:password])
    session[:user] = Digest::MD5.hexdigest(params[:password])
  else
    redirect '/login'
  end
  redirect '/'
end

def client
  OAuth2::Client.new('140998689277380', '25eb7d9c148183d465e3c1e48fafeade', 
    :site => 'https://graph.facebook.com',
    :parse_json => true
  )
end

get '/auth/facebook' do
  redirect client.web_server.authorize_url(
    :redirect_uri => redirect_uri, 
    :scope => 'email,offline_access'
  )
end

get '/auth/facebook/callback' do
  REDIS.set("users:#{session[:user]}:code", params[:code])
  access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
  user = access_token.get('/me')

  user.inspect
end

get '/code' do
  REDIS.get("users:#{session[:user]}:code")
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/auth/facebook/callback'
  uri.query = nil
  uri.to_s
end

get '/' do
  erb :home
end

#get '/friend/:userid' do
 #   "#{params[:name]}"
#end
