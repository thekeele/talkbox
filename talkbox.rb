#ruby talkbox for mac os x
#mRAK on the attACK

# global variables
@user = `id -un`
@names = []

def intro
	puts "***********************************************"
	puts "Hi #{@user.strip}, I'm the #{$0} script.\n"
	puts "***********************************************"
	puts "Welcome to Talkbox\n"
	puts "type 'help' to get started\n"
	puts "***********************************************"
end

def input
	# parse names and sayings into hash (runs once)
	@voices = Hash[*File.read('voices.txt').split(/# |\n/)]

	@voices.each do |name, saying|
		@names.push(name.strip)
	end
end

def corral
	# showcase of all the voices OS has to offter
	voice = 0
	@voices.each do |name, saying|
		print " #{name.strip} is speaking to you   [#{voice += 1}/#{@voices.count}]\n"
		talkbox = `say "#{saying}" -v "#{name.strip}"`
	end
end

def show_voices
	# display all voices for the user
	@voices.each do |name, saying|
		print name.strip + "\n"
	end
end

def main
	# variables
	colorful_language = ['fuck', 'shit', 'piss', 'cunt']
	command = ''
	prompt = '$ '
	name = 'Vicki'
	volume_amt = `osascript -e 'set volume 1'`

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
			#whenever I sweat it fogs up my glasses
			puts "usage: simply type something and press enter to get started\n\n"
			puts "Talkbox commands available to you:\n"
			puts "\thelp\t\tyour current position\n"
			puts "\tset volume NUM\tvolume of voice, ranges from 1 to 10"
			puts "\tuse random\tsample a random voice\n"
			puts "\tcorral\t\tsample all the voices offered to you\n"
			puts "\tshow voices\ta list of voices you can use\n"
			puts "\tuse VOICE\tuse a voice of your choosing(must be valid voice from list)\n"
			puts "\texit\t\tif your a party pooper"

		when /^set volume ([1-9]|10)$/
			# ehh the comparsion is just fucked....
			if command[/([1-9]|10)$/] >= volume_amt
				volume_amt = command[/([1-9]|10)$/]
				set_volume = `osascript -e 'set volume #{volume_amt}'`
				talkbox = `say "louder" -v "#{name.strip}"`
			else
				volume_amt = command[/([1-9]|10)$/]
				set_volume = `osascript -e 'set volume #{volume_amt}'`
				talkbox = `say "softer" -v "#{name.strip}"`
			end
		when 'use random'
			name = @names.sample
			talkbox = `say "Random" -v "#{name}"`
		when 'use ' + command.strip[4..-1]
			name = command.strip[4..-1]
			talkbox = `say "#{command.strip[4..-1]}" -v "#{name}"`
		when 'corral'
			corral
		when 'show voices'
			show_voices
		when 'drunk'
			print "Drink some rum you sailor!\n"
		when 'exit'
			print "\nThank you for using talkbox\n"
		else
			talkbox = `say "#{command}" -v "#{name.strip}"`
		end
	end
end

# this is where the magic happens
intro
input
main