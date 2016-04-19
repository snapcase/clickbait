require 'open-uri'
require 'json'
require 'cinch'

class Haddock
  include Cinch::Plugin

  match 'haddock'

  def execute(m)
    m.reply open('https://haddock.updog.se/?json') { |f| JSON.parse(f.read)['quote'] }
  end
end
