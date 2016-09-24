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

client.search("hate", :result_type => "recent").take(1).collect do |tweet|
    p "#{tweet.user.screen_name}: #{tweet.text}"
end
