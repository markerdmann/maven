require 'rubygems'
require 'json'

API_KEY = ""

data = {}
page = 1
while (response = `curl 'https://api.crowdflower.com/jobs/21236/judgments.json?limit=100&page=#{page}&key=#{API_KEY}'`) != "{}"
  page += 1
  data.merge!(JSON.parse(response))
end

results = {}
data.map do |unit|
  unit[1]["comment_categories"]["agg"].each do |category|
    if results[category]
      results[category] += 1
    else
      results[category] = 1
    end
  end if unit[1]["comment_categories"]["agg"]
end

p results