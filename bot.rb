require 'cinch'
require "cinch/plugins/identify"

class Seen < Struct.new(:who, :where, :what, :time)
  def to_s
    "[#{time.asctime}] #{who} was seen in #{where} saying #{what}"
  end
end


$me = "_67k"
$users = {}

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.nick   = $me
    c.channels = ["#6x7"]
    c.plugins.plugins = [Cinch::Plugins::Identify]
    c.plugins.options[Cinch::Plugins::Identify] = {
      :username => $me,
      :password => ENV['CINCH_PWD'],
      :type     => :nickserv,
    }
  end

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"
  end

  on :join do |m|
    if m.user.nick == bot.nick
      sleep 20
      #m.channel.op(bot.user)
      #m.reply "/msg chanserv op #6x7 _67k"
      User('ChanServ').send 'op #6x7 _67k'
    end
  end

  on :channel do |m|
    $users[m.user.nick] = Seen.new(m.user.nick, m.channel, m.message, Time.new)
  end

  on :channel, /^!seen (.+)/ do |m, nick|
    if nick == bot.nick
      sleep 20
      #m.channel.op(bot.user)
      #m.reply "/msg chanserv op #6x7 _67k"
      User('ChanServ').send 'op #6x7 _67k'
    end
  end

  on :channel do |m|
    $users[m.user.nick] = Seen.new(m.user.nick, m.channel, m.message, Time.new)
  end

  on :channel, /^!seen (.+)/ do |m, nick|
    if nick == bot.nick
      m.reply "That's me!"
    elsif nick == m.user.nick
      m.reply "That's you!"
    elsif $users.key?(nick)
      m.reply $users[nick].to_s
    else
      m.reply "I haven't seen #{nick}"
    end
  end

end

bot.start

