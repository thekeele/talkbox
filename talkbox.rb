class Talkbox
  # instance variables for self
  def initialize()
    # CONST name of user running script
    user = `id -un`
    @user = user.chomp

    os = `uname -a`
    current_os = os.strip.split(' ')
    version = current_os.first

    if version == 'Darwin'
      @os = 'osx'
    else
      @os = 'linux'
    end

    @name = ''
    @names = []

    # split each line by # char or newline char into array
    # splat operator converts array into arguments
    # hash is created from even number of arguments
    @voices = Hash[*File.read('voices.txt').split(/# |\n/)]

    @voices.each do |name, saying|
      @names.push(name.strip)
    end

    @volume = '5'
  end

  # welcome the user to talkbox
  def intro
    puts "************************************************"
    puts "Hi #{ @user.strip }, I'm the #{ $0 } script"
    puts "************************************************"
    puts "\tWelcome to Talkbox"
    puts "\ttype 'help' to get started"
    puts "************************************************"
  end

  def outro
    puts "************************************************"
    puts "Thank you for using talkbox, #{ @user.strip }"
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

  # executes talk command with text and name of speaker
  def talk(text, name)
    if @os == 'osx'
      `say "#{ text }" -v "#{ name.strip }"`
    else
      `echo "#{ text }" | espeak`
    end
  end

  def volume(command)
    new_volume = command[/(10|[1-9])$/].to_i
    set_volume = `osascript -e 'set volume #{ new_volume }'`
    @volume = @volume.to_i

    if new_volume > @volume
      self.talk('louder', @name)
    elsif new_volume < @volume
      self.talk('softer', @name)
    end

    @volume = new_volume
  end

  def quit?
    begin
      while char = STDIN.read_nonblock(1)
        return true if char == 'Q'
      end
      false
    rescue Errno::EINTR
      false
    rescue Errno::EAGAIN
      puts 'Errno::EAGAIN: Resource temporarily unavailable'
      false
    rescue EOFError
      true
    end
  end

  # showcase of all the voices OS has to offer
  def corral
    puts 'Press CTRL+D to Exit'
    voice = 0

    @voices.each do |name, saying|
      puts " #{ name.strip } says: #{ saying }   [#{ voice += 1 }/#{ @voices.count }]"

      talkbox_talk(saying, name.strip)

      break if quit?
    end
  end

  # display all voices for the user
  def voices
    @voices.each do |name, saying|
      puts name.strip
    end
  end

  def random
    @name = @names.sample

    self.talk('Random', @name)
  end

  def name(command)
    @name = command.strip[4..-1]

    self.talk(command, @name)

    return @name
  end
end
