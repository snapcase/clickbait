clickbait
=========

Description
-----------

Collection of plugins for use with the [cinch](https://github.com/cinchrb/cinch) framework.

Usage
-----

### bundler
Using [bundler](http://bundler.io) for project dependencies.

```
% gem install bundler
```

After cloning the repository, install gems.

```
% bundle install --path vendor/bundle
```

Configure
-------

### example.rb

```ruby
require 'bundler/setup'

require_relative 'plugins/youtube'
require_relative 'plugins/http_title'
require_relative 'plugins/twitch'

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "mybot"
    c.user = "something"
    c.server = "irc.freenode.net"
    c.channels = ["#chan1", "#chan2"]
    c.port = 7000
    c.ssl.use = true
    c.ssl.verify = true
    c.plugins.plugins = [Youtube, HTTPTitle, Twitch]
    c.plugins.options[Youtube] = { api_key: 'CHANGE_ME' }
    c.plugins.options[HTTPTitle] = { blacklist: [
      "youtube.com",
      "youtu.be",
      "twitch.tv"
    ] }
  end
end

bot.loggers.level = :info
bot.start
```

List of plugins
---------------

### Youtube
Post titles from youtube. You will need an API key, if you're feeling lazy just use the *HTTPTitle* plugin for similar functionality.

### HTTPTitle
Posts titles from urls mentioned in the channel(s). You can choose to blacklist certain domains to avoid interfering with other plugins. Also useful for sites that offer stale and boring titles not related to its content.

### Twitch
Used to collect information from a stream using the Twitch API.
