require 'cinch'

module Clickbait::Plugins
  class ThatsMyNick
    include Cinch::Plugin

    listen_to :connect, method: :on_connect
    listen_to :offline, method: :on_offline

    def initialize(*args)
      super
      @nick = bot.config.nick
    end

    def on_connect(m)
      return unless bot.nick != @nick
      User(@nick).monitor
    end

    def on_offline(m, user)
      User(@nick).unmonitor
      bot.nick = @nick
    end
  end
end
