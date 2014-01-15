#!/usr/bin/env ruby
require 'optparse'

#ruby talkbox for mac os x
#mRAK

# global variables
@prompt = '$ '
@command = ''
@user = `id -un`

def intro
	puts "Hi #{@user.strip}, I'm the #{$0} script.\n"
	puts "*************************************"
	puts "Welcome to Talkbox\n"
	puts "type help to get started\n"
end

def input
	# parse names and sayings into hash
	@voices = Hash[*File.read('voices.txt').split(/# |\n/)]
end

def corral
	# showcase of all the voices OS has to offter
	voice = 0
	@voices.each do |name, saying|
		print " #{name.strip} is speaking to you   [#{voice += 1}/#{@voices.count}]\n"
		talkbox = `say "#{saying}" -v "#{name.strip}"`
	end
end

def main
	# main program loop
	until @command == 'exit'
		print @prompt
		@command = STDIN.gets.chomp()

		if @command == 'corral'
			corral
		end
	end
end

intro
input
main

#read volume amt from args if volume_amt = 10
#set_volume = `osascript -e 'set volume #{volume_amt}'`

#voices = ["Albert", "Zarvox", "Alex", "Bruce", "Princess", "Ralph", "Vicki", "Victoria", "Whisper"]
#random_voice = ["Albert", "Zarvox", "Alex", "Bruce", "Princess", "Ralph", "Vicki", "Victoria", "Whisper"].sample

#read talk from args if present
#talk = "Welcome to Machine Learning"

#add flag for random
#talkbox = `say "#{talk}" -v "#{voices[1]}"`
#random_talkbox = `say "#{talk}" -v "#{random_voice}"`


#drink some rum you sailor

#talk like a [input]