require 'open-uri'
require 'json'
require 'cinch'

class Imdb
  include Cinch::Plugin

  listen_to :channel

  def info(id)
    url = "http://www.omdbapi.com/?i=#{id}&plot=short&r=json"
    if json = JSON.load(open(url))
      str = '%s (%d)' % [json['Title'], json['Year']]
      unless json['imdbRating'] == 'N/A'
        str << '. Ratings: %.1f/10 from %s users' % [json['imdbRating'], json['imdbVotes']]
      end
      str << '. Plot: %s' % [json["Plot"]]
    end
  end

  def listen(m)
    ids = m.message.scan(%r{(?:https?://)?www.imdb.com/title/(tt[0-9]+)/?}).flatten
    unless ids.empty?
      ids.each { |id| m.reply(info(id)) }
    end
  end
end
