#!/usr/bin/env ruby

#ruby talkbox for mac osx (untested linux support)
#mRAK on the attACK

# CONST name of user running script
USER = `id -un`

# instance variables for self
@name = 'Vicki'
@names = []
@os = ''
@volume = '5'

# welcome the user to talkbox
def intro
    puts "************************************************"
    puts "Hi #{USER.strip}, I'm the #{$0} script"
    puts "************************************************"
    puts "\tWelcome to Talkbox"
    puts "\ttype 'help' to get started"
    puts "************************************************"
end

def outro
    puts "************************************************"
    puts "Thank you for using talkbox, #{USER.strip}"
    puts "************************************************"
end

# whenever I sweat it fogs up my glasses
def help
    puts "usage: simply type something and press enter to get started\n\n"
    puts "Talkbox commands available to you:\n"
    puts "\thelp\t\tyour current position\n"
    puts "\tset volume NUM\tvolume of voice, ranges from 1 to 10"
    puts "\tcorral\t\tsample all the voices offered to you\n"
    puts "\tshow voices\ta list of voices you can use\n"
    puts "\tuse random\tsample a random voice\n"
    puts "\tuse VOICE\tuse a voice of your choosing(must be valid voice from list)\n"
    puts "\tdirty talk\tallow talkbox to use colorful language\n"
    puts "\tclean talk\tremove cuss words from talkbox\n"
    puts "\texit\t\tif your a party pooper"
end

# read in voice file and fill array of @names
def input
    # split each line by # char or newline char into array
    # splat operator converts array into arguments
    # hash is created from even number of arguments
    @voices = Hash[*File.read('voices.txt').split(/# |\n/)]

    @voices.each do |name, saying|
        @names.push(name.strip)
    end
end

# determine what OS script is running on
def what_os
	os = `uname -a`
	current_os = os.strip.split(' ')
	version = current_os.first

	if version == 'Darwin'
		return 'osx'
	else
		return 'linux'
	end
end

# executes talk command with text and name of speaker
def talkbox_talk(text, name)
    if @os == 'osx'
        `say "#{text}" -v "#{name.strip}"`
    else
        `echo "#{text}" | espeak`
    end
end

def set_volume(command)
    new_volume = command[/(10|[1-9])$/].to_i
    set_volume = `osascript -e 'set volume #{new_volume}'`
    @volume = @volume.to_i

    if new_volume > @volume
        talkbox_talk('louder', @name)
    elsif new_volume < @volume
        talkbox_talk('softer', @name)
    else
    end

    @volume = new_volume
end

# showcase of all the voices OS has to offer
def corral
	voice = 0
	@voices.each do |name, saying|
		print " #{name.strip} says: #{saying}   [#{voice += 1}/#{@voices.count}]\n"
		talkbox_talk(saying, name.strip)
	end
end

# display all voices for the user
def show_voices
	@voices.each do |name, saying|
		print name.strip + "\n"
	end
end

def use_random
    @name = @names.sample
    talkbox_talk('Random', @name)
end

def use_name(command)
    @name = command.strip[4..-1]
    talkbox_talk(command, @name)
end

def main
	# setup initial environment with clean talk, Vicki, and moderate volume
	colorful_language = ['fuck', 'shit', 'piss', 'cunt', 'bitch', 'whore', 'slut', 'damn', 'penis', 'pussy']
	prompt = '$ '
    @os = what_os
    set_volume(@volume)

    if ARGV[0] != nil
        command = ARGV[0]
        print "#{@name} wishes #{command} to you!\n"
        talkbox_talk(command, @name)
        command = 'exit'
    else
        intro
        command = ''
    end

	### during main program loop allow up and down arrow to scroll through previous commands
    ### catch interrupt during corral, shouldn't make user listen to whole thing

	# main program loop
	until command == 'exit'
		print prompt
		command = STDIN.gets.chomp()

		if colorful_language.any?{|w| command =~ /#{w}/}
			command = "drunk"
		end

		case command
		when 'help'
            help
		when /^set volume ([1-9]|10)$/
            set_volume(command)
		when 'corral'
			corral
		when 'show voices'
			show_voices
        when 'use random'
            use_random
        when /^use [a-zA-Z]+$/
            use_name(command)
		when 'drunk'
			print "Drink some rum you sailor!\n"
		when 'dirty talk'
            talkbox_talk("your such a whore bro", @name)
			colorful_language = []
		when 'clean talk'
            talkbox_talk("you made daddy really proud", @name)
			colorful_language = ['fuck', 'shit', 'piss', 'cunt', 'bitch', 'whore', 'slut', 'damn', 'penis', 'pussy']
        when 'exit'
            outro
		else
			talkbox_talk(command, @name)
		end
	end
end

# this is where the magic happens
input
main
