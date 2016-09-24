require 'unirest'
require 'twitter'
require 'dotenv'

#load environment variables from .env file
Dotenv.load

# set up connection to twitter bot
client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
    config.access_token = ENV['ACCESS_TOKEN']
    config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

client.search("from:realdonaldtrump", :result_type => "recent").take(1).collect do |tweet|
    p "#{tweet.user.screen_name}: #{tweet.text}"
end

# These code snippets use an open-source library.
response = Unirest.post "https://twinword-sentiment-analysis.p.mashape.com/analyze/",
  headers:{
    "X-Mashape-Key" => "XnKlAmUXLjmshcnfCeF7YfNDFcwAp17eaQijsngkJBFBBXeGPS",
    "Content-Type" => "application/x-www-form-urlencoded",
    "Accept" => "application/json"
  },
  parameters:{
    "text" => "great value in its price range!"
  }

  p response
