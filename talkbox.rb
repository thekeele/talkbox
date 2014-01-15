#!/usr/bin/env ruby
require 'optparse'

#ruby talkbox for mac os x
#mRAK

#read volume amt from args if present
volume_amt = 10
set_volume = `osascript -e 'set volume #{volume_amt}'`

voices = ["Albert", "Zarvox", "Alex", "Bruce", "Princess", "Ralph", "Vicki", "Victoria", "Whisper"]
#random_voice = ["Albert", "Zarvox", "Alex", "Bruce", "Princess", "Ralph", "Vicki", "Victoria", "Whisper"].sample

#read talk from args if present
talk = "Welcome to Machine Learning"

#add flag for random
talkbox = `say "#{talk}" -v "#{voices[1]}"`
#random_talkbox = `say "#{talk}" -v "#{random_voice}"`


#drink some rum you sailor

#talk like a [input]

