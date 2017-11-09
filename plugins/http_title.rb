require 'nokogiri'
require 'httpclient'
require 'cinch'

module Clickbait::Plugins
  class HTTPTitle
    include Cinch::Plugin

    # 405 = method not allowed
    CODES = [200, 405].freeze
    TYPES = ['text/html', 'text/xml', 'application/atom+xml'].freeze

    set :required_options, [:blacklist]

    listen_to :channel

    def initialize(*args)
      super
      @clnt = HTTPClient.new
      @clnt.cookie_manager = nil
      @clnt.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @clnt.default_header = { 'Accept' => 'text/html', 'Accept-Language' => 'en' }
      @options = { follow_redirect: true }
    end

    def get_title(url)
      host = URI.parse(url).host
      return unless host
      domain = host_without_www(host)
      # blacklisted domain
      return if config[:blacklist].include?(domain)
      url << '.rss' if domain =~ /(?:.+\.)?reddit(?:static)?\.com/
      req = @clnt.head(url, @options)
      # make sure it's a document that we can parse
      return unless CODES.include?(req.status_code) && TYPES.any? { |w| req.content_type[w] }
      doc = Nokogiri::HTML(@clnt.get_content(url))
      if domain == 'instagram.com'
        doc.at("meta[name='description']")['content']
      else
        title = doc.at('title')
        # couldn't find a title
        return unless title
        title = sanitize(title.text)
        title.eql?('Imgur') ? nil : title
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
      title.gsub(/\s{2,}|[\n\t]/, ' ')
    end
  end
end
