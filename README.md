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

After cloning the repository, install gems. Make sure that `bundle` is accessible through your `$PATH`. This will most likely be in `$HOME/.gem/ruby/2.2.0/bin/bundle` (your version might differ).

```
% bundle install --path vendor/bundle
```

Bundler will read the contents of the `Gemfile` and install dependencies.

Configure
-------

### example.rb

```ruby
require 'bundler/setup'

require_relative 'plugins/youtube'
require_relative 'plugins/http_title'
require_relative 'plugins/twitch'
require_relative 'plugins/oldurl'

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = "mybot"
    c.user = "something"
    c.server = "irc.freenode.net"
    c.channels = ["#chan1", "#chan2"]
    c.port = 7000
    c.ssl.use = true
    c.ssl.verify = true
    c.plugins.plugins = [Youtube, HTTPTitle, Twitch, OldURL]
    c.plugins.options[Youtube] = { api_key: 'CHANGE_ME' }
    c.plugins.options[HTTPTitle] = { blacklist: [
      "youtube.com",
      "youtu.be",
      "twitch.tv"
    ] }
    c.plugins.options[OldURL] = { db: 'sqlite://old.db' }
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

### OldURL
Reports if a URL has previously been posted in a channel. You can use it with a variety of adapters, see [Sequel](https://github.com/jeremyevans/sequel) for more information.
