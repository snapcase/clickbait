require 'bundler/setup'

module Clickbait
  # plugins
  Dir['plugins/*.rb'].each { |p| require_relative p }

  # bot
  bot = Cinch::Bot.new do
    configure do |c|
      c.nick = 'mybot'
      c.user = 'something'
      c.server = 'irc.freenode.net'
      c.channels = ['#chan1', '#chan2']
      c.port = 7000
      c.ssl.use = true
      c.ssl.verify = true
      c.plugins.plugins = Plugins.constants.map { |p| Plugins.const_get p }
      c.plugins.options[Plugins::Youtube] = { api_key: 'CHANGE_ME' }
      c.plugins.options[Plugins::Imdb]    = { api_key: 'get one at omdbapi.com' }
      c.plugins.options[Plugins::HTTPTitle] = { blacklist: [
        'youtube.com',
        'youtu.be',
        'twitch.tv',
        'imdb.com'
      ] }
    end
  end

  # party
  bot.loggers.level = :info
  bot.start
end
