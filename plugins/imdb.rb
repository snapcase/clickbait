require 'open-uri'
require 'json'
require 'cinch'

class Imdb
  include Cinch::Plugin

  listen_to :channel

  def info(id)
    url = "http://www.omdbapi.com/?i=#{id}&plot=short&r=json"
    if json = JSON.load(open(url))
       "%s (%d) Ratings: %.1f/10 from %s users. Plot: %s" % [json["Title"], json["Year"], json["imdbRating"], json["imdbVotes"], json["Plot"]]
    end
  end

  def listen(m)
    ids = m.message.scan(%r{(?:https?://)?www.imdb.com/title/(tt[0-9]+)/?}).flatten
    unless ids.empty?
      ids.each { |id| m.reply(info(id)) }
    end
  end
end
