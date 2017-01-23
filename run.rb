#!/usr/bin/env ruby

require_relative 'talkbox'

talkbox = Talkbox.new

# * splat operator
# for doesn't introduce a new scope (unlike each)

#ruby talkbox for mac osx (untested linux support)
#mRAK on the attACK

@name = talkbox.name('use Vicki')

# start talkbox at median volume
talkbox.volume('5')

# Initialize variables
prompt = '$ '
colorful_language =
  ['fuck', 'shit', 'piss', 'cunt', 'bitch',
   'whore', 'slut', 'damn', 'penis', 'pussy']

if ARGV[0] != nil
  # talk argument and exit
  command = ARGV[0]
  puts "#{ @name } wishes #{ command } to you!"
  talkbox.talk(command, @name)
  command = 'exit'
else
  # prepare interactive prompt
  talkbox.intro
end

### during main program loop allow up and down arrow to scroll through previous commands

# main program loop
until command == 'exit'
  command = nil

  print prompt

  command = STDIN.gets.chomp()

  if colorful_language.any?{ |w| command =~ /#{ w }/ }
    command = "drunk"
  end

  case command
  when 'help'
    talkbox.help
  when /^set volume ([1-9]|10)$/
    talkbox.volume(command)
  when 'corral'
    talkbox.corral
  when 'show voices'
    talkbox.voices
  when 'use random'
    talkbox.random
  when /^use [a-zA-Z]+$/
    @name = talkbox.name(command)
  when 'drunk'
    puts "Drink some rum you sailor!"
  when 'dirty talk'
    talbox.talk("your such a whore bro", @name)
    colorful_language = []
  when 'clean talk'
    talkbox.talk("you made daddy really proud", @name)
    colorful_language =
      ['fuck', 'shit', 'piss', 'cunt', 'bitch',
       'whore', 'slut', 'damn', 'penis', 'pussy']
  when 'exit'
    talkbox.outro
  else
    talkbox.talk(command, @name)
  end
end
