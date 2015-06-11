require 'open-uri'
require 'json'
require 'cinch'

class Twitch
  include Cinch::Plugin

  listen_to :channel

  def channel_info(user)
    json = JSON.load(open("https://api.twitch.tv/kraken/channels/#{user}", 
                          'Accept' => 'application/vnd.twitchtv.v3+json'), nil, symbolize_names: true)
    "%s playing %s (%s)" % json.values_at(:display_name, :game, :status)
  rescue OpenURI::HTTPError
    nil
  end

  def listen(m)
    users = m.message.scan(/(?:www.)?twitch\.tv\/([a-zA-Z0-9_]+)/).flatten
    users.each do |user| 
      content = channel_info(user)
      m.reply(content) unless content.nil?
    end
  end
end
