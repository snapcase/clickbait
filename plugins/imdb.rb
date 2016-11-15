require 'open-uri'
require 'json'
require 'cinch'

module Clickbait::Plugins
  class Imdb
    include Cinch::Plugin

    listen_to :channel

    def info(id)
      url = "http://www.omdbapi.com/?i=#{id}&plot=short&r=json"
      json = open(url) { |f| JSON.parse(f.read, symbolize_names: true) }
      return unless json
      str = format('%s (%d)', json[:Title], json[:Year])
      unless json[:imdbRating] == 'N/A'
        str << format('. Ratings: %.1f/10 from %s users', json[:imdbRating], json[:imdbVotes])
      end
      str << format('. Plot: %s', json[:Plot])
    end

    def listen(m)
      ids = m.message.scan(%r{(?:https?://)?www.imdb.com/title/(tt[0-9]+)/?}).flatten
      ids.each { |id| m.reply(info(id)) } unless ids.empty?
    end
  end
end
