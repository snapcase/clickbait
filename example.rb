require 'bundler/setup'

require_relative 'plugins/youtube'
require_relative 'plugins/http_title'

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "mybot"
    c.user = "something"
    c.server = "irc.freenode.net"
    c.channels = ["#chan1", "#chan2"]
    c.port = 7000
    c.ssl.use = true
    c.ssl.verify = true
    c.plugins.plugins = [Youtube, HTTPTitle]
    c.plugins.options[Youtube] = { api_key: 'CHANGE_ME' }
  end
end

bot.loggers.level = :info
bot.start
