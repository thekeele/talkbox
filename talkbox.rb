#!/usr/bin/env ruby

#ruby talkbox for mac osx (untested linux support)
#mRAK on the attACK

# global variables
@user = `id -un`
@names = []

# welcome the user to talkbox
def intro
    puts "************************************************"
    puts "Hi #{@user.strip}, I'm the #{$0} script\n"
    puts "************************************************"
    puts "\tWelcome to Talkbox\n"
    puts "\ttype 'help' to get started\n"
    puts "************************************************"
end

# whenever I sweat it fogs up my glasses
def help
    puts "usage: simply type something and press enter to get started\n\n"
    puts "Talkbox commands available to you:\n"
    puts "\thelp\t\tyour current position\n"
    puts "\tset volume NUM\tvolume of voice, ranges from 1 to 10"
    puts "\tuse random\tsample a random voice\n"
    puts "\tcorral\t\tsample all the voices offered to you\n"
    puts "\tshow voices\ta list of voices you can use\n"
    puts "\tuse VOICE\tuse a voice of your choosing(must be valid voice from list)\n"
    puts "\tdirty talk\tallow talkbox to use colorful language\n"
    puts "\tclean talk\tremove cuss words from talkbox\n"
    puts "\texit\t\tif your a party pooper"
end

# read in voice file and fill array of names
def input
    # parse names and sayings into hash (runs once)
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

# talk command for linux systems
def lin_talk(text)
	`echo "#{text}" | espeak`
end

# showcase of all the voices OS has to offer
def corral
	voice = 0
	@voices.each do |name, saying|
		print " #{name.strip} is speaking to you   [#{voice += 1}/#{@voices.count}]\n"
		if what_os == 'osx'
			talkbox = `say "#{saying}" -v "#{name.strip}"`
		else
			lin_talk(saying)
		end
	end
end

# display all voices for the user
def show_voices
	@voices.each do |name, saying|
		print name.strip + "\n"
	end
end

def main
	# setup initial environment with clean talk, Vicki, and moderate volume
	colorful_language = ['fuck', 'shit', 'piss', 'cunt', 'bitch', 'whore', 'slut', 'damn', 'penis', 'pussy']
	command = ''
	prompt = '$ '
	name = 'Vicki'
	volume_amt = `osascript -e 'set volume 5'`

	### during main program loop allow up and down arrow to scroll through previous commands

	# main program loop
	until command == 'exit'
		print prompt
		command = STDIN.gets.chomp()

		# fucking pirates always bee drinking man
		if colorful_language.any?{|w| command =~ /#{w}/}
			command = "drunk"
		end

		case command
		when 'help'
            help
		when /^set volume ([1-9]|10)$/
			# ehh the comparison is just fucked....louder or softer oh my!
			if command[/([1-9]|10)$/] >= volume_amt
				volume_amt = command[/([1-9]|10)$/]
				set_volume = `osascript -e 'set volume #{volume_amt}'`
				if what_os == 'osx'
					talkbox = `say "louder" -v "#{name.strip}"`
				else
					lin_talk('louder')
				end
			else
				volume_amt = command[/([1-9]|10)$/]
				set_volume = `osascript -e 'set volume #{volume_amt}'`
				if what_os == 'osx'
					talkbox = `say "softer" -v "#{name.strip}"`
				else
					lin_talk('softer')
				end
			end
		when 'use random'
			name = @names.sample
			if what_os == 'osx'
				talkbox = `say "Random" -v "#{name}"`
			else
				lin_talk('random')
			end

		### typing use + invalid name will break system as invalid name becomes the default name used, must fix
		when 'use ' + command.strip[4..-1]
			name = command.strip[4..-1]
			if what_os == 'osx'
				talkbox = `say "#{command.strip[4..-1]}" -v "#{name}"`
			else
				lin_talk(command.strip[4..-1])
			end
		### catch interrupt during corral, shouldn't make user listen to whole thing
		when 'corral'
			corral
		when 'show voices'
			show_voices
		when 'drunk'
			print "Drink some rum you sailor!\n"
		when 'exit'
			print "\nThank you for using talkbox, #{@user.strip}\n"
		when 'dirty talk'
			talkbox = `say "your such a whore bro" -v "#{name}"`
			colorful_language = []
		when 'clean talk'
			talkbox = `say "you made daddy really proud" -v "#{name}"`
			colorful_language = ['fuck', 'shit', 'piss', 'cunt', 'bitch', 'whore', 'slut', 'damn', 'penis', 'pussy']
		else
			if what_os == 'osx'
				talkbox = `say "#{command}" -v "#{name.strip}"`
			else
				lin_talk(command)
			end
		end
	end
end

# this is where the magic happens
intro
input
main
