require 'twit/client'

module Clickbait::Plugins
  class Twitter
    include Cinch::Plugin

    # you will need a twitter consumer key and secret
    set :required_options, [:consumer_key, :consumer_secret]

    # only listen to channel messages
    listen_to :channel

    def initialize(*args)
      super
      key_secret = config.values_at(:consumer_key, :consumer_secret)
      @clnt = Twit::Client.new(*key_secret)
    end

    def tweet(id)
      tweet = @clnt.tweet(id)
      name = tweet.user.name
      text = tweet.text.gsub(/\n+/,' ')
      "#{name} on Twitter: \"#{text}\""
    end

    def listen(m)
      ids = m.message.scan(%r{(?:https?://)?(?:www)?.twitter.com/\w+/status/(\d+)}).flatten
      ids.each { |id| m.reply(tweet(id)) } unless ids.empty?
    end
  end
end
