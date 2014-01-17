#ruby talkbox for mac os x
#mRAK on the attACK

# global variables
@user = `id -un`
@names = []

def intro
	puts "Hi #{@user.strip}, I'm the #{$0} script.\n"
	puts "*************************************"
	puts "Welcome to Talkbox\n"
	puts "type 'help' to get started\n"
end

def input
	# parse names and sayings into hash
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
	volume_amt = `osascript -e 'set volume 5'`

	# main program loop
	until command == 'exit'
		print prompt
		command = STDIN.gets.chomp()

		case command
		when 'help' 
			#must setup elaborate help case
			puts 'Good luck with that buddy'
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
		# breaks shit, must be clever here
		#when /^use [a-zA-Z]{1,12}$/
			# must only allow valid names, sys command return is good
			#name = command[/[a-zA-Z]{1,12}$/]
			#talkbox = `say "#{name.strip}" -v "#{name.strip}"`
		when 'use Random'
			name = @names.sample
			talkbox = `say "Random" -v "#{name}"`
		when 'corral'
			corral
		when 'show voices'
			show_voices
		when *colorful_language
			print "Drink some rum you sailor!\n"
		when 'exit'
			print "Thank you for using talkbox\n"
		else
			talkbox = `say "#{command}" -v "#{name.strip}"`
		end
	end
end

# this is where the magic happens
intro
input
main