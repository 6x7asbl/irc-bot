ssh Last login: Wed Apr  8 15:54:21 on tty??
You have mail.
You are using '.rvmrc', it requires trusting, it is slower and it is not compatible with other ruby managers,
you can switch to '.ruby-version' using 'rvm rvmrc to [.]ruby-version'
or ignore this warning with 'rvm rvmrc warning ignore /Users/cedric/Code/apptweak/.rvmrc',
'.rvmrc' will continue to be the default project file in RVM 1 and RVM 2,
to ignore the warning for all files run 'rvm rvmrc warning ignore all.rvmrcs'.

Using /Users/cedric/.rvm/gems/ruby-2.0.0-p451 with gemset apptweak
^[[A%                                                                                                                                                                                  ➜  apptweak git:(beta) ✗ powder restart
➜  apptweak git:(beta) ✗ ssh deploy@188.166.55.156
Welcome to Ubuntu 14.10 (GNU/Linux 3.16.0-28-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

  System information as of Wed Apr  8 10:05:03 EDT 2015

  System load:  0.0                Processes:           98
  Usage of /:   15.1% of 29.40GB   Users logged in:     1
  Memory usage: 53%                IP address for eth0: 188.166.55.156
  Swap usage:   0%

  => There are 3 zombie processes.

  Graph this data and manage this system at:
    https://landscape.canonical.com/

81 packages can be updated.
61 updates are security updates.

*** System restart required ***
Last login: Wed Apr  8 08:07:02 2015 from 207.155-242-81.adsl-dyn.isp.belgacom.be
deploy@BEDevTeam:~$ vim /home/deploy/irc/bot.rb 













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

