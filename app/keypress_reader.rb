require 'io/console'

class KeypressReader
  def initialize(stream=STDIN)
    @stream = stream
  end

  # Reads and returns a single char associated with a keypress.
  # Lightly adapted from https://gist.github.com/acook/4190379
  def read
    @stream.echo = false
    @stream.raw!

    input = @stream.getc.chr
    if input == "\e" then
      input << @stream.read_nonblock(3) rescue nil
      input << @stream.read_nonblock(2) rescue nil
    end
  ensure
    @stream.echo = true
    @stream.cooked!

    return input
  end
end
