require 'rest-client'
require 'json'
require 'cinch'

module Clickbait::Plugins
  class Imdb
    include Cinch::Plugin

    # an API key is required to use this plugin
    set :required_options, [:api_key]

    # only listen to channel messages
    listen_to :channel

    # the base API URL including the API key
    BASE_URL = "http://www.omdbapi.com/?plot=short&r=json"

    # @param [String] the imdb page ID
    # @return [String] string with various information
    def info(id)
      url = BASE_URL + "&i=#{id}&apikey=#{config[:api_key]}"
      response = RestClient.get(url)
      json = JSON.parse(response.body, symbolize_names:true)
      # couldn't find the movie
      return if json.key?(:Error)
      # return string
      imdb_info_string(json)
    end

    def listen(m)
      ids = m.message.scan(%r{(?:https?://)?www.imdb.com/title/(tt[0-9]+)/?}).flatten
      ids.each { |id| m.reply(info(id)) } unless ids.empty?
    end

    private
    # @param [Hash] the json payload
    # @return [String] formatted string with information
    def imdb_info_string(json)
      str = format('%s (%d)', json[:Title], json[:Year])
      unless json[:imdbRating] == 'N/A'
        str << format('. Ratings: %.1f/10 from %s users', json[:imdbRating], json[:imdbVotes])
      end
      str << format('. Plot: %s', json[:Plot])
    end
  end
end
