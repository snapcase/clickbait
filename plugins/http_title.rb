require 'nokogiri'
require 'httpclient'
require 'cinch'

class HTTPTitle
  include Cinch::Plugin

  set :required_options, [:blacklist]

  listen_to :channel

  def initialize(*args)
    super
    @clnt = HTTPClient.new
    @clnt.cookie_manager = nil
    @clnt.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  
  def get_title(url)
    domain = host_without_www(URI.parse(url).host)
    unless config[:blacklist].include?(domain)
      options = { follow_redirect: true }
      req = @clnt.head(url, options)
      if req.status_code == 200 && req.content_type.start_with?('text/html')
        doc = Nokogiri::HTML(@clnt.get_content(url, options))
        if title = doc.at('title')
          title = sanitize(title.text)
          return title.eql?("Imgur") ? nil : title
        end
      end
    end
  end

  def listen(m)
    urls = URI.extract(m.message, /https?/)
    urls.each do |url| 
      title = get_title(url)
      m.reply(title) if title
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
