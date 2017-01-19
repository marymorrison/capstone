require `httparty`
require 'twitter'
require 'omniauth-twitter'
require 'oauth'

class TwitterApiWrapper

  FOLLOWERS_BASE_URL = "https://api.twitter.com/1.1/followers/list.json"
  FOLLOWEES_BASE_URL = "https://api.twitter.com/1.1/friends/list.json"
  KEY = ENV["TWITTER_KEY"]
  SECRET = ENV["TWITTER_SECRET"]

  def self.listfollowers()

    client = OAuth::Client.new(KEY, SECRET, :site => FOLLOWERS_BASE_URL)

  end
end
