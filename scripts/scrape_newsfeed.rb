require 'rubygems'
require 'json'
require 'fastercsv'

JOB_ID = 21236
API_KEY = ""  #ARGV[0]

def scrape(code)

i = 0
url = "https://graph.facebook.com/me/home?access_token=#{code}"
header = ["name", "message"]
while (i += 1) < 40
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
  FasterCSV.open('data.csv', 'w') do |csv|
    csv << header
    rows.each do |row|
      csv << row
    end
  end
#  ret = `curl -T 'data.csv' -H 'Content-Type: text/csv' https://api.crowdflower.com/v1/jobs/#{JOB_ID}/upload.json?key=#{API_KEY}`
  url = response["paging"]["next"]
end

p "Done scraping"
# ret

end
