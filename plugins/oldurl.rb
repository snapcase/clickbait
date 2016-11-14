require 'sequel'
require 'cinch'

module Clickbait::Plugins
  class OldURL
    include Cinch::Plugin

    set :required_options, [:db]

    listen_to :channel

    def initialize(*args)
      super
      db = Sequel.connect(config[:db])
      db.create_table? :urls do
        primary_key :id
        String      :url
        String      :who
        String      :channel
        Time        :created_at
      end
      @urls = db[:urls]
    end

    def check_url(url, m)
      channel = m.channel.name
      nick = m.user.nick
      data = @urls[url: url, channel: channel]
      if data
        who, created_at = data.values_at(:who, :created_at)
        m.reply format('!old, posted by %s on %s', who, created_at.strftime('%c in %Z')) unless who == m.user.nick
      else
        @urls.insert(url: url, who: nick, channel: channel, created_at: Time.now)
      end
    end

    def listen(m)
      urls = URI.extract(m.message, /https?/)
      urls.each do |url|
        check_url(url, m)
      end
    end
  end
end
