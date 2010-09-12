require 'rubygems'
require 'json'
require 'fastercsv'

JOB_ID = 21232
API_KEY = ARGV[0]

i = 0
url = "https://graph.facebook.com/me/home?access_token=2227470867|2.lA7Par6Uzmd1lMZsLKbGow__.3600.1284282000-33502025|Ia075uB_bLZOcZV5rmroQEtKTRk"
header = ["name", "message"]
while (i += 1) < 40
  newsfeed = `curl '#{url}'`
  response = JSON.parse(newsfeed)
  data = response["data"]
  rows = []
  data.each do |post|
    name = post["from"]["name"]
    message = post["message"]
    rows << [name, message]
  end
  FasterCSV.open('data.csv', 'w') do |csv|
    csv << header
    rows.each do |row|
      csv << row
    end
  end
  `curl -T 'data.csv' -H 'Content-Type: text/csv' https://api.crowdflower.com/v1/jobs/#{JOB_ID}/upload.json?key=#{API_KEY}`
  url = response["paging"]["next"]
end
