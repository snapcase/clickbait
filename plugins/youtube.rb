require 'open-uri'
require 'json'
require 'cinch'

module Clickbait::Plugins
  class Youtube
    include Cinch::Plugin

    set :required_options, [:api_key]

    listen_to :channel

    # @param  [Array]
    # @return [Array, nil]
    def title(id)
      url  = "https://www.googleapis.com/youtube/v3/videos?id=#{id.join(',')}&" + \
             "key=#{config[:api_key]}&part=snippet&fields=items(id,snippet(title))"
      json = JSON.load(open(url))
      json["items"].map { |item| "#{item["id"]} : #{item["snippet"]["title"]}" }
    rescue OpenURI::HTTPError
      nil
    end

    def listen(m)
      id = m.message.scan(
        %r{
          (?:youtube(?:-nocookie)?\.com\/
          (?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|
          \S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})
        }x
      ).uniq
      unless id.empty?
        titles = title(id)
        m.reply titles.join(", ")
      end
    end
  end
end
