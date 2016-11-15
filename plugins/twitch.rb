require 'open-uri'
require 'json'
require 'cinch'

module Clickbait::Plugins
  class Twitch
    include Cinch::Plugin

    listen_to :channel

    def channel_info(user)
      url = "https://api.twitch.tv/kraken/channels/#{user}"
      json = open(url, 'Accept' => 'application/vnd.twitchtv.v3+json') do |f|
        JSON.parse(f.read, symbolize_names: true)
      end
      format('%s playing %s (%s)', *json.values_at(:display_name, :game, :status))
    rescue OpenURI::HTTPError
      nil
    end

    def listen(m)
      users = m.message.scan(%r{(?:www.)?twitch\.tv\/([a-zA-Z0-9_]+)}).flatten
      users.each do |user|
        content = channel_info(user)
        m.reply(content) if content
      end
    end
  end
end
