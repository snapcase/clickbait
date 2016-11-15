require 'cinch'

module Clickbait::Plugins
  class Hej
    include Cinch::Plugin

    match(/.*(?=.*h)(?=.*e)(?=.*j)(?!.*[a-dfgik-z]).*[!.]?/i, use_prefix: false)

    def execute(m)
      m.reply "Hallå hej, #{m.user.nick}!"
    end
  end
end
