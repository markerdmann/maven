require 'rubygems'
require 'json'
require 'pp'

API_KEY = "71530356758fab72bb60645750e08d16af01fa19"

data = {}
page = 1
while (response = `curl 'https://api.crowdflower.com/jobs/21236/judgments.json?limit=100&page=#{page}&key=#{API_KEY}'`) != "{}"
  page += 1
  data.merge!(JSON.parse(response))
end

summary = {}
user_counts = {}
user_totals = {}
messages = {}
messages["by_name"] = {}
messages["by_category"] = {}
data.map do |unit|
  name = unit[1]["name"]
  message = unit[1]["message"]
  unit[1]["comment_categories"]["agg"].each do |category|
    summary[category] = summary[category] ? summary[category] + 1 : 1
    user_counts[category] ||= {}
    user_counts[category][name] = user_counts[category][name] ? user_counts[category][name] + 1 : 1
    messages["by_name"][name] ||= []
    messages["by_name"][name] << [category, message]
    messages["by_category"][category] ||= []
    messages["by_category"][category] << [name, message]
    user_totals[name] ||= {}
    user_totals[name]["total"] = user_totals[name]["total"] ? user_totals[name]["total"] + 1 : 1
  end if unit[1]["comment_categories"]["agg"]
end

category_totals = user_counts
user_counts.each do |k1,v1|
  user_counts[k1].each do |k2,v2|
    user_counts[k1][k2] = v2.to_f / user_totals[k2]["total"]
    user_totals[k2][k1] = user_counts[k1][k2]
  end
end

output = {
  :summary => summary,
  :user_counts => user_counts,
  :category_totals => category_totals,
  :user_totals => user_totals,
  :messages => messages
}
File.open('../data', 'w') {|f| f.write(Marshal.dump(output))}