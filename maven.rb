require 'rubygems'
require 'bundler'
require 'erb'

Bundler.setup

require 'sinatra'
require 'oauth2'
require 'json'
require 'scripts/scrape_newsfeed'

enable :sessions

configure do
  require 'redis'
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/index' do
  erb :index
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
  erb :home
end

get '/code' do
  REDIS.get("users:#{session[:user]}:code")
end

get '/scrape' do
  code = REDIS.get("users:#{session[:user]}:code")
  access_token = client.web_server.get_access_token(code, :redirect_uri => redirect_uri)
  ret = scrape(access_token)
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

#create csv file
get '/social/:key' do
  i = 0
  key_item = params[:key]
  url = "https://graph.facebook.com/me/home?access_token=#{key_item}"
  header = ["name", "message"]
  while (i += 1) < 50
    newsfeed = `curl '#{url}'`
    response = JSON.parse(newsfeed)
    data = response["data"]
    rows = []
    data.each do |post|
      p name = post["from"]["name"]
      p message = post["message"]
      next if message == "No data available" || message == "" || message == nil
      rows << [name, message]
    end
    FasterCSV.open("#{key_item}.csv", 'a') do |csv|
      csv << header
      rows.each do |row|
        csv << row
      end
    end
    #`curl -T 'data.csv' -H 'Content-Type: text/csv' https://api.crowdflower.com/v1/jobs/#{JOB_ID}/upload.json?key=#{API_KEY}`
    url = response["paging"]["next"]
  end
  erb :show_message
end

#add items to crowdflower
get '/social/cf_push/:job_id/:api_key' do
  JOB_ID = params[:job_id]
  API_KEY = params[:api_key]
  `curl -T 'data.csv' -H 'Content-Type: text/csv' https://api.crowdflower.com/v1/jobs/#{JOB_ID}/upload.json?key=#{API_KEY}`
end

#get '/friend/:userid' do
 #   "#{params[:name]}"
#end
