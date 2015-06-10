require 'nokogiri'
require 'net/http'
require 'cinch'

class HTTPTitle
  include Cinch::Plugin

  listen_to :channel
  
  def initialize(*args)
    super
    @blacklist = [
      "youtu.be",
      "youtube.com",
      "apina.biz",
      "i.imgur.com"
    ]
  end

  def title(url)
    url = URI.parse(url)
    domain = host_without_www(url.host)
    unless @blacklist.include?(domain)
      ssl = (url.scheme == "https" ? true : false)
      Net::HTTP.start(url.host, url.port, use_ssl: ssl) do |http|
        head = http.head(url.request_uri)
        if head.code == "200" && head['Content-Type'].start_with?('text/html')
          req = http.get(url.request_uri)
          if req.code == "200"
            doc = Nokogiri::HTML(req.body)
            title = doc.at('title')
            title ? sanitize(title.text) : nil
          end
        end
      end
    end
  end

  def listen(m)
    urls = URI.extract(m.message, /https?/)
    titles = urls.map { |url| title(url) }.compact
    unless titles.empty?
      m.reply titles.join(", ")
    end
  end

  private
  def host_without_www(host)
    host = host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

  def sanitize(title)
    title.strip!
    title.gsub!(/\s{2,}|[\n\t]/, ' ')
    return title
  end
end
