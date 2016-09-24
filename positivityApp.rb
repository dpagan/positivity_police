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

tweetFrom = ARGV[0]

tweet = client.search("from:#{tweetFrom}", :result_type => "recent").take(1).collect.next

tweetText = tweet.text
tweetId = tweet.id

# These code snippets use an open-source library.
response = Unirest.post "https://twinword-sentiment-analysis.p.mashape.com/analyze/",
  headers:{
    "X-Mashape-Key" => "XnKlAmUXLjmshcnfCeF7YfNDFcwAp17eaQijsngkJBFBBXeGPS",
    "Content-Type" => "application/x-www-form-urlencoded",
    "Accept" => "application/json"
  },
  parameters:{
    "text" => "#{tweetText}"
  }

score = response.body["score"].to_f
rating = ""

if score >= 0.75
    rating = "heavenly"
elsif score >= 0.50
    rating = "very positive"
elsif score >= 0.25
    rating = "positive"
elsif score >= 0.1
    rating = "neutral leaning positive"
elsif (score - 0).abs < 0.1
    rating = "neutral"
elsif score <= -0.75
    rating = "practically Hitler"
elsif score <= -0.50
    rating = "very negative"
elsif score <= -0.25
    rating = "negative"
elsif score <= -0.1
    rating = "neutral leaning negative"
end

link = "http://twitter.com/#{tweetFrom}/status/#{tweetId}"
client.update("The most recent post from @#{tweetFrom}  has a positivity rating of #{rating} (#{score.round(3)}). #{link}")
